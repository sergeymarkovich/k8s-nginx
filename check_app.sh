#!/bin/bash

timestamp=$(date +"%Y-%m-%d %T")
log_file="app_log.log"
app_url_root="http://192.168.1.63/"
app_url_dog="http://192.168.1.63/dogs/dogs.txt"
app_url_cat="http://192.168.1.63/cats/cats.txt"
cron_job="@daily ./check_app.sh"

# if log file not existing - create
if [ ! -f "$log_file" ]; then
    touch "$log_file"
fi

# if cron job not existing - create
if ! crontab -l | grep -q "$cron_job"; then
    (crontab -l ; echo "$cron_job") | crontab -
fi

# function for write logs
perform_curl_request() {
    local url=$1
    local result=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ $result -eq 200 ]; then
        echo "$timestamp - 200 | $url the app is available" >> "$log_file"
    else
        echo "$timestamp - $result | $url the app is not available" >> "$log_file"
    fi
}

# make curl request for url
perform_curl_request "$app_url_root"
perform_curl_request "$app_url_dog"
perform_curl_request "$app_url_cat"


