#!/bin/bash

PROJECTENV="pipelineg"
HOME_DIR=`pwd`
ENV=$HOME_DIR/env
REGION="europe-west2"
PROJECTID="rishu-gcp-project-20210414"
STORAGECLASS="STANDARD"
KEY_FILE=$HOME_DIR/credentials/pipeline-g-infrastructure-editor.json

echo "Setting up terraform backend bucket"
gcloud auth activate-service-account --key-file $KEY_FILE
gsutil mb -p $PROJECTID -c $STORAGECLASS -b on -l $REGION gs://tf-backend-state
if [ $? -eq 1 ]
then
    echo "Found error while creating bucket in google cloud."
    echo "usage|: gsutil mb -l <region> gs://<bucket-name>"
    exit 1
fi


echo "Installing Python Environment in Local Mode"
echo "Project Env. Name: $PROJECTENV"

echo "1. Creating project env."
python3 -m venv $ENV/$PROJECTENV/env

echo "2. Pip upgrade"
source $ENV/$PROJECTENV/env/bin/activate
pip install pip --upgrade

echo "3. Installing Dependencies"
pip3 install -r ../requirements.txt

echo "4. Activating the env."
source $ENV/$PROJECTENV/env/bin/activate

exit 0
