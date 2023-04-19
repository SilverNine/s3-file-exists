#!/bin/sh

if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_S3_REGION" ]; then
  echo "AWS_S3_REGION is not set. Quitting."
  exit 1
fi

if [ -z "$FILE" ]; then
  echo "FILE is not set. Quitting."
  exit 1
fi

# log
echo "Checking for file at s3://${AWS_S3_BUCKET}/${FILE}"

# Execute a head-object command
aws s3api head-object --bucket ${AWS_S3_BUCKET} --key ${FILE}

# XXX: we are just checking the error code, but should check the result for a 404, and raise error in other cases
if [ $? == 0 ]
then
  echo "S3_FILE_EXISTS=true" >> $GITHUB_ENV
else
  echo "S3_FILE_EXISTS=false" >> $GITHUB_ENV
fi
