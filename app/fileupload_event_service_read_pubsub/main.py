import os 
import json
from google.cloud import pubsub_v1
import pandas as pd

'''
    This cloud function reads the data from the cloud bucket into Pubsub for further processing
'''

PROJECT_ID = os.environ['GOOGLE_CLOUD_PROJECT']
TOPIC_PATH = "eu-file-upload-event-service-data-topic"
ACCEPTED_FILES=['csv','txt','tsv']

def publish_message(message):
    '''
        publish a message to the pub-sub topic
    '''
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(PROJECT_ID, TOPIC_PATH)

    data = json.dumps(message).encode("utf-8")

    try:
        future = publisher.publish(topic_path, data)
        print("Published Message {}".format(data))
    except Exception as e: 
        print("Found exception while publishing the message to pub-sub topic {}".format(TOPIC_PATH))
        raise


def read_from_storage(bucket, file, contenttype):
    '''
        read from gcs and return a json data
    '''

    filename = "gcs://{}/{}".format(bucket, file)

    if ACCEPTED_FILES[0] in contenttype:
        print("Reading csv file. {}".format(filename))
        df = pd.read_csv(filename, delimiter=",")
        
    else:
        print("File {} not in the accepted list of files parser".format(filename))

    return df.to_json(orient='records')

        


def main(event, context):
    '''
        main trigger to read data from storage into pubsub
    '''
    print("Starting reading data from storage into pubsub")

    eventid = event['md5Hash']
    contenttype = event['contentType']
    bucket = event['bucket']
    file = event['name']

    content = read_from_storage(bucket, file, contenttype)

    message = {
        "EventID": eventid,
        "Bucket" : bucket,
        "File": file, 
        "ContentType": contenttype,
        "Content": content
    }

    publish_message(message)