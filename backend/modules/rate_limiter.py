"""This file contains a middleware class for limiting request the request rate"""
# Most of this code is from:
# https://github.com/projectweekend/Falcon-PostgreSQL-API-Seed/blob/master/app/middleware/rate_limit.py
from time import time
import logging
import redis
import falcon

# create logger
LOGGER = logging.getLogger('main')
LOGGER.setLevel(logging.INFO)
# create console handler and set level to info
ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
# add ch to logger
LOGGER.addHandler(ch)

class RateLimiter(object):
  """This class is a middleware that prevents excessive requests to the server"""
  def __init__(self, limit=100, window=60):
    self.limit = limit
    self.window = window
    self.redis = redis.StrictRedis(host='redis', port=6379)

  def process_request(self, req, res):
    """This function is checks the request path in the redis
    to make sure it has not made too many requests recently"""
    requester = req.env['REMOTE_ADDR']

    # un-comment if you want to ignore calls from localhost
    # if requester == '127.0.0.1':
    #   return

    key = "{0}: {1}".format(requester, req.path)

    try:
      remaining = self.limit - int(self.redis.get(key))
    except (ValueError, TypeError):
      remaining = self.limit
      self.redis.set(key, 0)

    expires_in = self.redis.ttl(key)

    if expires_in == -1:
      self.redis.expire(key, self.window)
      expires_in = self.window

    res.append_header('X-RateLimit-Remaining: ', str(remaining - 1))
    res.append_header('X-RateLimit-Limit: ', str(self.limit))
    res.append_header('X-RateLimit-Reset: ', str(time() + expires_in))

    if remaining > 0:
      self.redis.incr(key, 1)
    else:
      LOGGER.info('Rate Limit hit: {%s}', key)
      raise falcon.HTTPTooManyRequests(
          title='Rate Limit Hit',
          description='Blocked: Too many requests'
      )
