#!/usr/bin/bash

function myhelp() {

printf -- "Telegram Channel Push Bot ${version}\n"
printf -- "  --send-message        | -m      -  Send a message from stdin\n"
printf -- "  --edit-message INT    | -e INT  -  Re-write message with content of stdin\n"
printf -- "  --reply-message INT   | -r INT  -  Reply to message with content of stdin\n"
printf -- "  --send-document FILE  | -d FILE -  Send a file of any type as a document\n"
printf -- "  --send-photo FILE     | -p FILE -  Send a picture\n"
printf -- "  --send-animation FILE | -g FILE -  Send GIF or H.264/MPEG-4 AVC video without sound\n"
printf -- "  --delete-message INT            -  Deletes a message\n"
printf -- "  --forward-message FROM INT      -  Forward a message to other chat\n"
printf -- "  --copy-message FROM INT         -  Forward a message without backlink\n"
printf -- "  --pin-message INT               -  Pin a message\n"
printf -- "  --unpin-message INT             -  Unpin a message\n"
printf -- "\nMandatory environmental variables\n"
printf -- "  bot_token:   Token of the bot provided by Bot Father\n"
printf -- "  channel_id:  Target channel with bot as admin\n"
printf -- "  api_url:     The Bot Api Server to use (local to bypass 50MiB file limit)\n"

}

function send_message() {

    t_text=`cat`
    curl -X POST -H "Content-Type:multipart/form-data" -F chat_id="$channel_id" --form-string text="$t_text" -F parse_mode="HTML" "${api_url}/bot${bot_token}/sendMessage" | jq '.'
    printf -- "\n"

}

function edit_message() {

    msg_id=$1
    t_text=`cat`

    curl -X POST -H "Content-Type:multipart/form-data" -F chat_id="$channel_id" -F message_id="$msg_id" --form-string text="$t_text" -F parse_mode="HTML" "${api_url}/bot${bot_token}/editMessageText" | jq '.'
    printf -- "\n"

}

function reply_message() {

    replyto=$1
    t_text=`cat`

    curl -X POST -H "Content-Type:multipart/form-data" -F chat_id="$channel_id" -F reply_to_message_id=$replyto --form-string text="$t_text" -F parse_mode="HTML" "${api_url}/bot${bot_token}/sendMessage" | jq '.'
    printf -- "\n"


}

function send_document() {

    doc=$1

    curl -F document=@"$doc" "${api_url}/bot${bot_token}/sendDocument?chat_id=${channel_id}" | jq '.'
    printf -- "\n"

}

function send_photo() {

    photo=$1

    curl -F photo=@"$photo" "${api_url}/bot${bot_token}/sendPhoto?chat_id=${channel_id}" | jq '.'
    printf -- "\n"

}

function send_animation() {

    animation=$1

    curl -F animation=@"$animation" "${api_url}/bot${bot_token}/sendAnimation?chat_id=${channel_id}" | jq '.'
    printf -- "\n"

}

function delete_message() {

    msg=$1

    curl -X POST -H "Content-Type:multipart/form-data" -F chat_id="$channel_id" -F message_id="$msg" "${api_url}/bot${bot_token}/deleteMessage" | jq '.'
    printf -- "\n"

}

function forward_message() {

    from=$1
    msg=$2
    curl -X POST  -H "Content-Type:multipart/form-data"  -F chat_id="$channel_id" -F from_chat_id=$from -F message_id="$msg" "${api_url}/bot${bot_token}/forwardMessage" | jq '.'
    printf -- "\n"

}

function copy_message() {

    from=$1
    msg=$2
    curl -X POST  -H "Content-Type:multipart/form-data"  -F chat_id="$channel_id" -F from_chat_id=$from -F message_id="$msg" "${api_url}/bot${bot_token}/copyMessage" | jq '.'
    printf -- "\n"

}

function pin_message() {

    msg=$1
    curl -F chat_id="$channel_id" -F message_id="$msg" "${api_url}/bot${bot_token}/pinChatMessage" | jq '.'
    printf -- "\n"

}

function unpin_message() {

    msg=$1
    curl -F chat_id="$channel_id" -F message_id="$msg" "${api_url}/bot${bot_token}/unpinChatMessage" | jq '.'
    printf -- "\n"

}

for arg in "$@"
do
    case $arg in
        --help|-h)
            myhelp
            exit
            ;;
        --send-message|-m)
            shift
            send_message
            exit
            ;;
        --edit-message|-e)
            shift
            edit_message $1
            exit
            ;;
        --reply-message|-r)
            shift
            reply_message $1
            exit
            ;;
        --send-document|-d)
            shift
            send_document $1
            exit
            ;;
        --send-photo|-p)
            shift
            send_photo $1
            exit
            ;;
        --send-animation|-g)
            shift
            send_animation $1
            exit
            ;;
        --delete-message)
            shift
            delete_message $1
            exit
            ;;
        --forward-message)
            shift
            forward_message $1 $2
            exit
            ;;
        --copy-message)
            shift
            copy_message $1 $2
            exit
            ;;
        --pin-message)
            shift
            pin_message $1
            exit
            ;;
        --unpin-message)
            shift
            unpin_message $1
            exit
            ;;
        *)
            ;;
    esac
done
