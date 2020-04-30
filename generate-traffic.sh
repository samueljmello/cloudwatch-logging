#!/bin/bash

# get parameters from script invocation
while getopts ":h:" opt; do
  case $opt in
    h) HOST="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# check for host name
if [[ -z "${HOST}" ]]; then
    echo "You must provide a valid host name to CURL. Do not include http(s) or slashes (/) Use the -h parameter."
    exit 1;
fi

# declare arrays for randomly selecting request structure
declare -a METHODS=(GET PUT POST DELETE)
declare -a ERROR_OR_NOT=(0 1)

# do until user aborts
while [[ true ]]
do
    # get a random method from the METHODS array
    METHOD_NUM=$(( $RANDOM % ${#METHODS[@]} ))
    METHOD=${METHODS[$METHOD_NUM]}

    # set up url
    URL="http://${HOST}"

    # determine if error
    if [[ $(( $RANDOM % ${#ERROR_OR_NOT[@]} )) == 1 ]]; then
        URL="${URL}/404error"
    fi

    # make curl request
    echo "Sending ${METHOD} request to: '${URL}'"
    curl --silent --output /dev/null -X ${METHOD} ${URL}

    # sleep to avoid hammering this isntance too hard
    sleep .25s
done