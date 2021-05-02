import os
from google.cloud import firestore

'''
This cloud function code will detect files uploaded in S3 bucket and generate file metadata information.

Workflow: S3 (raw) -> Cloud Function (upload event) -> Firestore (store the data)
'''

PROJECT_ID = os.environ['GOOGLE_CLOUD_PROJECT']
COLLECTION_NAME = "eu-file-upload-event-service-collection"

def add_message(message, event_name):
    '''
        Adding message to the firestore
    '''

    print("Adding message into the firestore")
    firestore_client = firestore.Client()

    try: 
        db = firestore_client.collection(COLLECTION_NAME).document(event_name)
        db.set(message)
    except Exception as e: 
        print("Exception found during entering data into firestore. {}".format(e))
        raise


def main(event, context):
    
    print("Starting trigger function based on S3 event")

    event_name = "event-{}".format(event['md5Hash'])

    response = {
        "event":{
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
    }

    print("Event generated. {}".format(response))

    add_message(response, event_name)

    return response

