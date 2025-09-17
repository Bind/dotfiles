#!/bin/bash

use-aws-creds() {
    if [ "$#" -ne 1 ]; then
        echo "use-aws-creds <client>"
        echo "    clients: pixly, cfa"
        return 1
    fi
    echo "Copying credentials from $1/credentials to .aws/credentials"

    cp ~/.aws/credentials ~/.aws/tmp_credentials
    cp ~/.aws/$1/credentials ~/.aws/credentials
}