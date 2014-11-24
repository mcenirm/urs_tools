#!/bin/bash

# https://wiki.earthdata.nasa.gov/display/URSFOUR/Working+With+The+URS+API

if [[ $# -eq 0 ]] ; then
  echo Usage: "$0" userid [...]
  exit 1
fi

URS_URL='https://uat.urs.earthdata.nasa.gov'

# authentication
token_json=$(curl -s --netrc -X POST "${URS_URL}/oauth/token?grant_type=client_credentials") || exit $?
access_token=$(echo "$token_json" | python -c 'import json; import sys; print json.load(sys.stdin)["access_token"]')

for userid in "$@" ; do
  echo "++ ${userid}"
  curl -s -H "Authorization: Bearer ${access_token}" "${URS_URL}/api/users/${userid}" | python -m json.tool
  echo
done


