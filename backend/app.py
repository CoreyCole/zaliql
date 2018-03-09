"""This is the root of the python web server application"""
# python modules
import logging
import falcon
# app middlewares
from middlewares.cors import CORSComponent
from middlewares.rate_limiter import RateLimiterComponent
from middlewares.database import DatabaseComponent
# app resources
from resources.columns import ColumnsResource
from resources.functions import FunctionsResource
from resources.tables import TablesResource
from resources.test import TestResource

RATE_LIMIT = 5        # limits 5 requests
RATE_LIMIT_WINDOW = 5 # per 5 seconds

# create logger
INFO_LOGGER = logging.getLogger('main')
INFO_LOGGER.setLevel(logging.INFO)
# create console handler and set level to info
CH = logging.StreamHandler()
CH.setLevel(logging.INFO)
# add CH to logger
INFO_LOGGER.addHandler(CH)

INFO_LOGGER.info('starting server')

DATABASE = DatabaseComponent()
APP = falcon.API(middleware=[
    CORSComponent(),
    RateLimiterComponent(limit=RATE_LIMIT, window=RATE_LIMIT_WINDOW),
    DATABASE
])
APP.req_options.auto_parse_form_urlencoded = True
APP.add_route('/test', TestResource())
APP.add_route('/tables', TablesResource(DATABASE))
APP.add_route('/columns/{table_name}', ColumnsResource(DATABASE))
APP.add_route('/function/{function_name}', FunctionsResource(DATABASE, INFO_LOGGER))
