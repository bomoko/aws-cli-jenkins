FROM alpine
RUN apk add --update --no-cache --virtual .build-deps gcc musl-dev python3 python3-dev nodejs-current npm yarn && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip install --ignore-installed aws-sam-cli

COPY . /app/

