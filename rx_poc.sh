#!/bin/bash

# Initialize weather report log file if it doesn't exist
log_file="rx_poc.log"
if [[ ! -f $log_file ]]; then
  echo -e "day\tmonth\tyear\tobs_temp\tfc_temp" > $log_file
fi

# Prompt the user to enter a city
read -p "Enter a city name: " city

# Display a message with the entered city and obtain the weather information from the city entered
echo "You entered: $city"
curl -s "wttr.in/$city?T" --output weather_report

# To extract current temperature
obs_temp=$(grep -m 1 '°.' weather_report | grep -Eo -e '-?[[:digit:]].*')
if [[ -z $obs_temp ]]; then
  echo "Unable to retrieve current temperature for $city."
  exit 1
fi
echo "The current temperature of $city: $obs_temp"

# To extract the forecast temperature for noon tomorrow
fc_temp=$(head -23 weather_report | tail -1 | grep '°.' | cut -d 'C' -f2 | grep -Eo -e '-?[[:digit:]].*')
if [[ -z $fc_temp ]]; then
  echo "Unable to retrieve forecasted temperature for noon tomorrow for $city."
  exit 1
fi
echo "The forecasted temperature for noon tomorrow for $city: $fc_temp C"

# Prompt the user to enter Country and City
read -p "Enter the Country and City, separated by a /: " CTZ

# Use command substitution to store the current day, month, and year in corresponding shell variables:
day=$(TZ="$CTZ" date -u +%d)
month=$(TZ="$CTZ" date -u +%m)
year=$(TZ="$CTZ" date -u +%Y)

# Record the data in the log file
record=$(echo -e "$day\t$month\t$year\t$obs_temp\t$fc_temp C")
echo -e "$record" >> $log_file

# Clean up temporary files
rm -f weather_report
