

'''
This cloud function code will detect files uploaded in S3 bucket and generate file metadata information.

Workflow: S3 (raw) -> Cloud Function (upload event) -> Pub/Sub (Publish file metadata)
'''

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
        "Created": event['timeCreated'],
        "Updated": event['updated']
    }

    print("Event generated. {}".format(response))

    return response

