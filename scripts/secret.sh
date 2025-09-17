#!/bin/bash

secret() {
    # Generate a secure random secret using OpenSSL
    local SECRET=$(openssl rand -base64 32)
    echo "Generated Secret: $SECRET"
}