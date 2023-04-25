FROM python:3.7-alpine

LABEL version="0.1.0"
LABEL repository="https://github.com/SilverNine/s3-file-exists-action"
LABEL maintainer="SilverNine <akasilvernine@gmail.com>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.27.120'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
