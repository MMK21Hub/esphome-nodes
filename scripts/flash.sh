#!/bin/bash

FILE=$1

if [[ -z $FILE ]]; then
  echo "Please provide the path to an ESPHome config file" 1>&2
  exit 1
fi 

if ! [[ -f $FILE ]]; then
  echo "File doesn't exist: $FILE" 1>&2
  exit 1
fi

DEVICE_REGEXP='(?<=^# DEVICE=).*(?=$)' # https://regex101.com/r/uac7QX/1
DEVICE=$(grep --perl-regexp --only-matching "$DEVICE_REGEXP" "$FILE")

if [[ -n "$DEVICE" ]]; then
  if ! [[ -e "$DEVICE" ]]; then
    echo "Device not plugged in: $DEVICE" 1>&2
    exit 1
  fi

  DEVICE_ARG="--device $DEVICE"
fi

ESPHOME='../bin/python3.9 -m esphome'
$ESPHOME run $DEVICE_ARG $FILE