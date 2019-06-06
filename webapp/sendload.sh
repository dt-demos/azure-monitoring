#!/bin/bash

# simple script to make requests against the coffee shop demo app
# how to run example for 30 seconds.  If no time specified will run for 15 seconds 
# ./sendload.sh https://webapp9999999.azurewebsites.net 30

APP_URL=$1
DURATION_SECONDS=$2

if [ -z "$1" ] ; then
  echo "Missing APP_URL argument"
  exit 1
fi

# this is safe-guard to prevent infinit loop
if [ -z "$2" ] ; then
  DURATION_SECONDS=15
fi

echo "======================================"
echo "Load Test Launched in:"
echo "APP_URL = $APP_URL"
echo "DURATION_SECONDS = $DURATION_SECONDS"
echo "======================================"

end=$(( SECONDS+$DURATION_SECONDS ))
while [ $SECONDS -lt $end ]; do
    echo "Calling @ $SECONDS seconds into test"
    curl "$APP_URL" --silent --output /dev/null
    curl "$APP_URL"/placeorder.jsp?id=10 --silent --output /dev/null
    curl "$APP_URL"/about.jsp --silent --output /dev/null
    sleep 2;
done;
exit 0