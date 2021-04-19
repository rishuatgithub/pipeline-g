#!/bin/bash

PROJECTENV="pipelineg"
ENV=$1
HOME_DIR=`pwd`

if [ "$#" -ne 1 ];
then
    echo "Argument Not Found. Expected 1 Found $#."
    echo "Usage: sh env-setup.sh ARG1"
    echo "Accepted Values: LOCAL, SERVER"
    exit 1
fi

if [[ $ENV -eq "LOCAL" ]];
then
    echo "Installing Python Environment in Local Mode"
    echo "Project Env. Name: $PROJECTENV"
    python3 -m venv ~/pyenv/$PROJECTENV/env
    source ~/pyenv/$PROJECTENV/env/bin/activate
    pip install pip --upgrade
    
else
    echo "Installing Python Environment in Server Mode"
    python3 -m venv ~/$PROJECTENV/env
    source ~/$PROJECTENV/env/bin/activate
    pip install pip --upgrade

    echo "source ~/$PROJECTENV/env/bin/activate" >> ~/.bashrc
    source ~/.bashrc
fi


source ~/pyenv/$PROJECTENV/env/bin/activate

echo "Installing Dependencies"
pip3 install -r $HOME_DIR/requirements.txt

exit 0
