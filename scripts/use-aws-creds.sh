#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "use-aws-creds <client>"
    echo "    clients: pixly, cfa"
    exit
fi
echo Copying credentials from  $1/credentials to .aws/credentials


cp ~/.aws/credentials cp ~/.aws/tmp_credentials
cp ~/.aws/$1/credentials ~/.aws/credentials