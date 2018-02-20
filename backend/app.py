"""This is the root of the python web server application"""
# python modules
import json
from wsgiref import simple_server
import logging
import falcon
import sys
# app modules
from modules.rate_limiter import RateLimiter

RATE_LIMIT = 2        # limits 2 requests
RATE_LIMIT_WINDOW = 5 # per 5 seconds

LOGGER = logging.getLogger('main')

class TestResource(object):
  """Experimental endpoint for testing"""
  def on_get(self, req, res):
    """Experimental endpoint handler for testing"""
    res.content_type = 'application/json'
    res.status = falcon.HTTP_200
    res.body = json.dumps({'message': 'hello'})

APP = falcon.API(middleware=[
    RateLimiter(limit=RATE_LIMIT, window=RATE_LIMIT_WINDOW)
])
APP.add_route('/test', TestResource())

if __name__ == '__main__':
  LOGGER.info('starting server')
  HTTPD = simple_server.make_server('0.0.0.0', 5000, APP)
  LOGGER.info('started server')
  HTTPD.serve_forever()
