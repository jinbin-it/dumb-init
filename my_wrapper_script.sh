#!/bin/bash

#Start the get config info
./config.sh 
config_status=$?
if [ $config_status -ne 0 ]; then
  echo "Failed to get config: $status"
  exit $status
fi

# Start the sshd process
/usr/sbin/sshd
ssh_status=$?
if [ $ssh_status -ne 0 ]; then
  echo "Failed to start sshd: $status"
  exit $status
fi

# Start the java process
./java.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start java: $status"
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep java |grep -q -v grep
  java_STATUS=$?
  ps aux |grep sshd |grep -q -v grep
  sshd_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $java_STATUS -ne 0 ]; then
    echo "Java  processes has already exited."
    exit 1
  fi
done

