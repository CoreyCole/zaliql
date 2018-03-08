"""Functions Resource"""
import json
import falcon

"""Functions Resource"""
class FunctionsResource(object):
  """Endpoint for calling functions in the database"""
  def __init__(self, database_cursor, info_logger):
    self.cursor = database_cursor
    self.info_logger = info_logger

  def on_post(self, req, resp, function_name):
    """Calls the passed function on the database"""
    self.info_logger.info('params {%s}', req.params)
    self.cursor.callproc(function_name, req.params)
    status = self.cursor.fetchone()[0]
    resp.content_type = 'application/json'
    resp.status = falcon.HTTP_200
    resp.body = json.dumps({'status': status})
    self.info_logger.info('params {%s}', status)