#!/bin/bash

onport() {
    if [ "$#" -ne 1 ]; then
        echo "onport <port>"
        return 1
    fi
    lsof -i :$1
}