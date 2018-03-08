import json
import falcon

"""Columns Resource"""
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
