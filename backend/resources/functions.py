"""Functions Resource"""
import json
import logging
import falcon
from psycopg2 import InternalError, ProgrammingError

def call_function(cursor, function_name, request_params, function_docs):
  """Creates the paramater list for the given function name and request_param dict"""
  info_logger = logging.getLogger('info')

  if function_name in function_docs:
    doc = function_docs[function_name]
    param_list = []
    for param in doc['params']:
      data = request_params[param['name']]
      type = param['type']
      info_logger.info('data=%s', data)
      if type is 'int':
        data = int(data)
      elif type is 'numeric':
        data = float(data)
      elif data is 'null':
        data = None
      param_list.append(data)

    info_logger.info('Calling function {%s} with params %s', function_name, param_list)
    cursor.callproc(function_name, param_list)
    return cursor.fetchone()[0]
  else:
    info_logger.info('Error invalid function name called {%s}', function_name)
    return None

class FunctionsResource(object):
  """Endpoint for calling functions in the database"""
  def __init__(self, database_cursor, docs):
    self.cursor = database_cursor
    self.info_logger = logging.getLogger('info')
    self.functions = dict(docs['functions'])

  def on_get(self, req, resp, function_name):
    """Gets documentation information about the given function_name"""
    self.info_logger.info('GET function {%s}', function_name)
    if function_name not in self.functions:
      resp.content_type = 'application/json'
      resp.status = falcon.HTTP_500
      resp.body = json.dumps({'status': 'invalid function name'})
    else:
      resp.content_type = 'application/json'
      resp.status = falcon.HTTP_200
      resp.body = json.dumps(self.functions.get(function_name))

  def on_post(self, req, resp, function_name):
    """Calls the passed function on the database"""
    status = None
    params = json.load(req.bounded_stream)
    self.info_logger.info('POST function {%s} call with params %s', function_name, params)

    try:
      status = call_function(self.cursor, function_name, params, self.functions)
    except (InternalError, ProgrammingError) as err:
      self.cursor.connection.rollback()
      resp.content_type = 'application/json'
      resp.status = falcon.HTTP_500
      resp.body = json.dumps({
          'status': str(err),
          'function_name': function_name,
          'params': params
      })
    else:
      self.cursor.connection.commit()
      resp.content_type = 'application/json'
      resp.status = falcon.HTTP_200
      resp.body = json.dumps({
          'function_name': function_name,
          'params': params,
          'status': status
      })
      self.info_logger.info('body={%s}', resp.body)
