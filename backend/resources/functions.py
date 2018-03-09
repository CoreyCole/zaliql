"""Functions Resource"""
import json
import falcon
from psycopg2 import InternalError, ProgrammingError

def call_function(cursor, function_name, request_params, info_logger):
  """Creates the paramater list for the given function name and request_param dict"""
  if function_name == 'matchit_propensity_score':
    param_list = []
    param_name_list = [
        'sourceTable',
        'primaryKey',
        'treatment',
        'covariatesArr',
        'k',
        'outputTable'
    ]
    for param_name in param_name_list:
      if param_name == 'covariatesArr' and not isinstance(request_params['covariatesArr'], list):
        param_list.append([request_params['covariatesArr']])
      elif param_name == 'k':
        param_list.append(int(request_params[param_name]))
      else:
        param_list.append(request_params[param_name])
    info_logger.info('Parsed param list {%s}', param_list)
    cursor.callproc(function_name, param_list)
  else:
    info_logger.info('Error invalid function name called {%s}', function_name)
    return None
  return cursor.fetchone()[0]

class FunctionsResource(object):
  """Endpoint for calling functions in the database"""
  def __init__(self, database, info_logger):
    self.cursor = database
    self.info_logger = info_logger

  def on_post(self, req, resp, function_name):
    """Calls the passed function on the database"""
    self.info_logger.info('POST function {%s} call with params %s', function_name, req.params)
    status = None
    try:
      status = call_function(self.cursor, function_name, req.params, self.info_logger)
    except (InternalError, ProgrammingError) as err:
      self.cursor.connection.rollback()
      resp.content_type = 'application/json'
      resp.status = falcon.HTTP_500
      resp.body = json.dumps({'status': str(err)})
    else:
      resp.content_type = 'application/json'
      resp.status = falcon.HTTP_200
      resp.body = json.dumps({'status': status})
