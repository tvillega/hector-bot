#!/usr/bin/bash

source $(pwd)/.env

function get_last_message() {

    curl https://api.telegram.org/bot${bot_token}/getUpdates | jq '.result[-1]' 

}

function get_n_message() {

    local n="$1"

    curl https://api.telegram.org/bot${bot_token}/getUpdates | jq ".result[-${n}]"

}

for arg in "$@"
do
    case $arg in
        --get-last)
            shift
            get_last_message
            exit
            ;;
        --get-n-message)
            shift
            get_n_message "$1"
            exit
            ;;
        *)
            ;;
    esac
done
