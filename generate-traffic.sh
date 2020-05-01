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
declare -a STATUSES=(NONE 404 500)

# do until user aborts
while [[ true ]]
do
    # get a random method from the METHODS array
    METHOD_NUM=$(( $RANDOM % ${#METHODS[@]} ))
    METHOD=${METHODS[$METHOD_NUM]}

    # decide what kind of status to return
    STATUS_NUM=$(( $RANDOM % ${#STATUSES[@]} ))
    STATUS=${STATUSES[$STATUS_NUM]}

    # set up url
    URL="http://${HOST}"

    # determine if 404
    if [[ ${STATUS} == "404" ]]; then
      URL="${URL}/404error" # file actually doesn't exist
    elif [[ ${STATUS} == "500" ]]; then
      URL="${URL}/500error.php" # file is a php error
    else
      URL="${URL}/index.html"
    fi

    # make curl request
    echo "Sending ${METHOD} request to: '${URL}'"
    curl --silent --output /dev/null -X ${METHOD} ${URL}

    # sleep to avoid hammering this isntance too hard
    sleep .25s
done