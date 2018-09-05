#!/bin/bash

egrep "admin" /etc/passwd >& /dev/null
if [ $? -ne 1 ]
then
    userdel admin
fi

config=`curl -s http://rap2api.taobao.org/app/mock/83734/example/1535618090035`

name=`echo $config | jq .userid | awk -F "\"" '{print $2}' | awk -F "\"" '{print $1}'`
pass=`echo $config | jq .password | awk -F "\"" '{print $2}' | awk -F "\"" '{print $1}'`

echo "you are setting username : ${name}"
echo "you are setting password : ${pass} for ${name}"

sudo useradd -m  $name
if [ $? -eq 0 ];then
   echo "user ${name} is created successfully!!!"
else
   echo "user ${name} is created failly!!!"
   exit 1
fi

echo ${name}:${pass} | chpasswd  &>/dev/null
if [ $? -eq 0 ];then
   echo "${name}'s password is set successfully"
   exit 0
else
   echo "${name}'s password is set failly!!!"
   exit 1
fi
