import os
from google.cloud import storage

os.environ['GOOGLE_APPLICATION_CREDENTIALS']=os.path.join(os.getcwd(),'credentials/pipeline-g-gcp-resource-editor.json')
projectid="rishu-gcp-project-20210414"

def get_files_to_upload(): 
    data_path = os.path.join(os.getcwd(),'data')
    
    print("List all the files in the local data path : {}".format(data_path))

    files_list = []
    for root, dir, files in os.walk(data_path): 
        for file in files: 
            _, fileext = os.path.splitext(file)
            folder = root.split('/')[-1]
            if fileext in ACCEPTED_FILE_EXT:
                files_list.append((root,folder,file))
    
    print(files_list)
    return files_list

def list_bucket(): 
    storage_client = storage.Client()
    buckets = storage_client.list_buckets()
    bucket_list=[ bucket.name for bucket in buckets]
    
    return bucket_list


def upload(): 
    print("Uploading the file to the bucket")

    bucket_name = list_bucket()[0]
    print(bucket_name)
    root, dir, file = get_files_to_upload()[0]
    source_file_name = os.path.join(root,file)
    destination_blob_name = os.path.join(dir, file)

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    print(
        "File {} uploaded to {}.".format(
            source_file_name, destination_blob_name
        )
    )
    
    



if __name__ == '__main__': 
    print("Starting the upload data program")
    ACCEPTED_FILE_EXT=['.xls','.csv','.xlsx','.tsv','.json']
    get_files_to_upload()
    list_bucket()
    upload()