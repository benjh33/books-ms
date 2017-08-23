#!/bin/bash

# docker run -it --rm \
#   -v $PWD/client/components:/source/client/components \
#   -v $PWD/client/test:/source/client/test \
#   -v $PWD/src:/source/src \
#   -v $PWD/target:/source/target \
#   -p 8080:8080 \
#   --env TEST_TYPE=watch-front \
#   vfarcic/books-ms-tests

# docker-compose -f docker-compose-dev.yml \
#     run --service-ports feTestsLocal

PORT=`docker inspect \
    --format='{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort}}'\
    booksms_app_1`

PROXY_SERVER=`cat /etc/hosts | grep proxy | awk '{print$1}'`

curl -H 'Content-Type: application/json' -X PUT -d \
    '{"_id": 1, 
    "title": "My First Book",
    "author": "John Doe",
    "description": "Not a very good book"}' \
    http://proxy:$PORT/api/v1/books | jq '.'

curl -H 'Content-Type: application/json' -X PUT -d \
    '{"_id": 2, 
    "title": "My Second Book",
    "author": "John Doe",
    "description": "Not a bad book"}' \
    http://proxy:$PORT/api/v1/books | jq '.'

curl -H 'Content-Type: application/json' -X PUT -d \
    '{"_id": 3, 
    "title": "My Third Book",
    "author": "John Doe",
    "description": "Failed writers club"}' \
    http://proxy:$PORT/api/v1/books | jq '.'

curl http://proxy:$PORT/api/v1/books | jq '.'
curl http://proxy:$PORT/api/v1/books/_id/1 | jq '.'

