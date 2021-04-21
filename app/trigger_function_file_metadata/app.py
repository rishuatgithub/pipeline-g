
'''
This cloud function code will detect files uploaded in S3 bucket and generate file metadata information.

Workflow: S3 (raw) -> Cloud Function (upload event) -> Pub/Sub (Publish file metadata)
'''