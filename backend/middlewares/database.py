"""This file contains a middleware for processing database session requests"""
import sys
import logging
import psycopg2

def database_connection(error_logger):
  """Establishes the database connection"""
  connection = None
  try:
    connection = psycopg2.connect(
        "dbname='maddb' user='madlib' host='db' port='5432' password='password'"
    )
  except psycopg2.OperationalError as err:
    error_logger.error('Unable to establish database connection! {%s}', err)
    sys.exit(1)
  else:
    return connection

class DatabaseComponent(object):
  """Initiates a new Session for incoming request and closes it in the end."""
  def __init__(self, error_logger):
    self.error_logger = error_logger
    self.connection = database_connection(self.error_logger)

  def process_resource(self, req, resp, resource, params):
    """Processes the given resource and mutates it"""
    if resource is not None:
      if self.connection.closed:
        self.connection = database_connection(self.error_logger)
      resource.connection = self.connection
      resource.cursor = self.connection.cursor()

  def process_response(self, req, resp, resource):
    """Processes the given resource and closes the cursor"""
    if hasattr(resource, 'cursor'):
      resource.cursor.close()
