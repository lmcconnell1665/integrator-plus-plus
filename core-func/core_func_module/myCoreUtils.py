"""
Core Utilities
"""

import os
from azure.servicebus import ServiceBusClient, ServiceBusMessage
from dotenv import load_dotenv
import logging

# Only for Local Development - Load environment variables from the .env file
# logging.info("Loading environment variables for .env file")
# load_dotenv('../../../.env')

def send_single_message(sender, msg):
    message = ServiceBusMessage(body=str(msg), subject='Employee Email', application_properties={'source': 'Database1'}, content_type='application/json')
    sender.send_messages(message)

def post_msg_to_queue(queue_name: str, msg: dict) -> bool:

    CONNECTION_STR = 'Endpoint=sb://dev-ipp-svc-bus.servicebus.windows.net/;SharedAccessKeyName=AnotherKey;SharedAccessKey=nLrDf3vTbVWJ2F/U5MWU5JbfXK9DDlFW9+ASbO+ztVY=;EntityPath=test-queue-01'

    servicebus_client = ServiceBusClient.from_connection_string(conn_str=CONNECTION_STR, logging_enable=True)

    with servicebus_client:
        sender = servicebus_client.get_queue_sender(queue_name=queue_name)
        with sender:
            send_single_message(sender, msg)
            return True
