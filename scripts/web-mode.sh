#!/bin/bash

web-mode() {
    local FORCE='false'
    local MODE='work'

    while test $# -gt 0; do
      case "$1" in
        -h|--help)
        shift
        echo "web-mode <mode>"
        echo "modes: work, play"
        shift
        return 0
          ;;
        -f)
          shift
          FORCE='true'
          ;;
        *)
          MODE=$1
          shift
          ;;
      esac
    done

    local currenttime=$(date +%H) 
    if [[ "$currenttime" < "18" ]] && [[ "$currenttime" > "09" ]] && [[ $MODE == 'play' ]] && [[ $FORCE == 'false' ]]; then
        echo $currenttime   
        echo 'no play during work hours';
        return 1
    fi 

    echo "Copying host file from ~/.dotfiles/templates/web-mode/host-$MODE to /etc/hosts"

    sudo cp ~/dotfiles/templates/web-mode/host-$MODE /etc/hosts
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}