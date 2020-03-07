#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "onport <port>"
    exit
fi
lsof -i :$1