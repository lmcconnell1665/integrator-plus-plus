import logging
import sys, os

import azure.functions as func

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from core_func_module import myCoreUtils

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    if name:
        myCoreUtils.post_msg_to_queue('test-queue-01', {'message': 'hello2'})
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        myCoreUtils.post_msg_to_queue('test-queue-01', {'message': 'hello'})
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )
