import os
import json
from google.cloud import pubsub_v1


'''
This cloud function code will detect files uploaded in S3 bucket and generate file metadata information.

Workflow: S3 (raw) -> Cloud Function (upload event) -> Pub/Sub (Publish file metadata)
'''

PROJECT_ID = os.environ['GOOGLE_CLOUD_PROJECT']
TOPIC_ID = "file-upload-event-service-topic"

def publish_message(message):
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)

    data = json.dumps(message).encode("utf-8")

    try:
        future = publisher.publish(topic_path, data)
        print("Published Message ID: {}".format(future))
    except Exception as e:
        print("Exception found while publishing message. {}".format(e))
        raise


def main(event, context):
    
    print("Starting trigger function based on S3 event")

    response = {
        "EventID": event['md5Hash'],
        "EventType": "S3",
        "ContentType": event['contentType'],
        "Bucket": event['bucket'],
        "File": event['name'],
        "File_Size": event['size'],
        "Metageneration": event['metageneration'],
        "DownloadLink": event['mediaLink'],
        "ProjectID": PROJECT_ID,
        "Created": event['timeCreated'],
        "Updated": event['updated']
    }

    print("Event generated. {}".format(response))

    publish_message(response)

    return response

