#! /bin/bash

#Initialize weather report log file
echo -e "day\tmonth\tyear\tobs_temp\tfc_temp">rx_poc.log

# Promt the user to enter a city
read -p "Enter a city name: " city

# Display a message with the entered city and obtain the weather information from the city you entered
echo "You entered: $city"
curl -s wttr.in/$city?T --output weather_report

#To extract Current Temperature
obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 '°.' | grep -Eo -e '-?[[:digit:]].*')
echo "The current Temperature of $city: $obs_temp"

# To extract the forecast tempearature for noon tomorrow
fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep '°.' | cut -d 'C' -f2 | grep -Eo -e '-?[[:digit:]].*')
echo "The forecasted temperature for noon tomorrow for $city : $fc_temp C"

# Promt the user to enter Country and City
read -p "Enter the Country and City, separated by a /: " CTZ

# Use command substitution to store the current day, month, and year in corresponding shell variables:
day=$(TZ="$CTZ" date -u +%d)
month=$(TZ="$CTZ" date +%m)
year=$(TZ="$CTZ" date +%Y)

record=$(echo -e "$day\t$month\t$year\t$obs_temp\t$fc_temp C")
echo $record>>rx_poc.log


#rm -r rx_poc.log
#rm -r weather_report
