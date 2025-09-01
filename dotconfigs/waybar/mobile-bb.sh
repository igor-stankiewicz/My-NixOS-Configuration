#!/usr/bin/env bash

modem_info=$(mmcli -L)
modem_id=$(echo "$modem_info" | grep -oP '/Modem/\K\d+')

if [ -z "$modem_id" ]; then
    # No modem detected, print nothing so Waybar hides the module
    exit 0
fi

modem_data=$(mmcli -m "$modem_id")

# Extract details
signal=$(echo "$modem_data" | grep 'signal quality' | grep -oP '\d+')
tech_raw=$(echo "$modem_data" | grep 'access tech' | sed -E 's/.*access tech *: *//')
operator=$(echo "$modem_data" | grep 'operator name' | sed -E 's/.*operator name *: *//')
modem_name=$(echo "$modem_data" | grep 'model' | sed -E 's/.*model *: *//')
state=$(echo "$modem_data" | grep 'state' | sed -E 's/.*state *: *//')

# Fallback for operator name
if [ -z "$operator" ]; then
    operator=$(echo "$modem_data" | grep 'apn' | sed -E 's/.*apn *: *//')
fi

# Translate tech
case "$tech_raw" in
    lte) tech="4G LTE" ;;
    umts) tech="3G UMTS" ;;
    hspa) tech="3G HSPA" ;;
    nr5g) tech="5G NR" ;;
    edge) tech="2G EDGE" ;;
    gprs) tech="2G GPRS" ;;
    *) tech="$tech_raw" ;;
esac

# Generate signal bar
if [ -z "$signal" ] || [ "$signal" -eq 0 ]; then
    bar="[-----]"
else
    bars=$(( signal / 20 ))
    bar="["
    for ((i=0; i<5; i++)); do
        if [ $i -lt $bars ]; then
            bar+="■"
        else
            bar+="─"
        fi
    done
    bar+="]"
fi

# Output logic
if echo "$state" | grep -qi "connected"; then
    echo "$operator $tech $bar"
else
    echo "$modem_name: connection inactive"
fi