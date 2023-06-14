#!/usr/bin/env bash

COPY_TO_FOLDER="/home/chenbin"
SCRIPT_NAME="s3_data_downloader.py"

echo "Copy $SCRIPT_NAME to '$COPY_TO_FOLDER' folder"
# cp s3_data_downloader.py /scripts
chmod 777 deploy.sh
cp deploy.sh $COPY_TO_FOLDER
echo ""

echo "Start download data sets"
if [ $# == 0 ];
then
    echo "Parameters doesn't exist"
    exit 1
elif [ $# -lt 5 ];
then
    echo "Parameters size less than 5"
    exit 1
fi

S3_PATH=$1
OBS_ACCESS_KEY=$2
OBS_SECRET_KEY=$3
LOCAL_DIRECTORY=$4
ENPOINT_URL=$5

echo ""
echo "python $SCRIPT_NAME
    --s3_path ${S3_PATH}
    --obs_access_key ${OBS_ACCESS_KEY}
    --obs_secret_key ${OBS_SECRET_KEY}
    --local_directory ${LOCAL_DIRECTORY}
    --endpoint_url ${ENPOINT_URL}
"

python $SCRIPT_NAME \
    --s3_path ${S3_PATH} \
    --obs_access_key ${OBS_ACCESS_KEY} \
    --obs_secret_key ${OBS_SECRET_KEY} \
    --local_directory ${LOCAL_DIRECTORY} \
    --endpoint_url ${ENPOINT_URL} \