"""Tables Resource"""
import json
import falcon

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