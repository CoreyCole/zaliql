"""This is the root of the python web server application"""
# python modules
import json
from wsgiref import simple_server
import logging
import falcon
# app middlewares
from middlewares.cors import CORSComponent
from middlewares.rate_limiter import RateLimiterComponent
from middlewares.database_cursor import DatabaseCursorComponent

RATE_LIMIT = 5        # limits 5 requests
RATE_LIMIT_WINDOW = 5 # per 5 seconds

# create logger
LOGGER = logging.getLogger('main')
LOGGER.setLevel(logging.INFO)
# create console handler and set level to info
CH = logging.StreamHandler()
CH.setLevel(logging.INFO)
# add CH to logger
LOGGER.addHandler(CH)

class TestResource(object):
  """Experimental endpoint for testing"""
  def on_get(self, req, resp):
    """Experimental endpoint handler for testing"""
    resp.content_type = 'application/json'
    resp.status = falcon.HTTP_200
    resp.body = json.dumps({'message': 'hello'})

class TablesResource(object):
  """Endpoint for table names in the database"""
  def __init__(self, database_cursor):
    """Initializes the tables resource"""
    self.cursor = database_cursor

  def on_get(self, req, resp):
    """Returns a list of table names from the database"""
    self.cursor.callproc('get_tables')
    table_list = self.cursor.fetchone()[0]
    resp.content_type = 'application/json'
    resp.status = falcon.HTTP_200
    resp.body = json.dumps({'tables': table_list})

class ColumnsResource(object):
  """Endpoint for column names in the database"""
  def __init__(self, database_cursor):
    self.cursor = database_cursor

  def on_get(self, req, resp, table_name):
    """Returns a list of column names given a table_name"""
    self.cursor.callproc('get_columns', [table_name])
    column_list = self.cursor.fetchone()[0]
    resp.content_type = 'application/json'
    resp.status = falcon.HTTP_200
    resp.body = json.dumps({'columns': column_list})

class FunctionsResource(object):
  """Endpoint for calling functions in the database"""
  def __init__(self, database_cursor):
    self.cursor = database_cursor

  def on_post(self, req, resp, function_name):
    """Calls the passed function on the database"""
    # self.cursor.callproc(params.function)
    resp.content_type = 'application/json'
    resp.status = falcon.HTTP_200
    resp.body = json.dumps(req.params)
    LOGGER.info('params {%s}', req.params)

DATABASE_CURSOR = DatabaseCursorComponent()
APP = falcon.API(middleware=[
    CORSComponent(),
    RateLimiterComponent(limit=RATE_LIMIT, window=RATE_LIMIT_WINDOW),
    DATABASE_CURSOR
])
APP.req_options.auto_parse_form_urlencoded = True
APP.add_route('/test', TestResource())
APP.add_route('/tables', TablesResource(DATABASE_CURSOR))
APP.add_route('/columns/{table_name}', ColumnsResource(DATABASE_CURSOR))
APP.add_route('/function/{function_name}', FunctionsResource(DATABASE_CURSOR))

if __name__ == '__main__':
  LOGGER.info('starting server')
  HTTPD = simple_server.make_server('0.0.0.0', 5000, APP)
  LOGGER.info('started server')
  HTTPD.serve_forever()
