#!/usr/bin/env bash

myVariable="lines"

echo -n "no newline"; echo -n " between these "; echo $myVariable
decalre -r myReadOnlyVar="This Variable is Read-Only"
echo $myReadOnlyVar

while read f
	do echo $f
done < myShellScript.sh

echo "What is your name?"
read name
echo "What is your pretend password?"
read -s pass
read -p "Animal? " animal

echo "name: $name, pass: $pass, animal: $animal"

read -p "Who am I? " server_name
while [[ -z $server_name ]]
do
	read -p "Who am I? " server_name
done

echo "My server name is: $server_name"

echo "What is my system type? "
select sys_type in "Ubuntu-ML" "Ubuntu-Miner" "Ubuntu-Server" "Raspian-Desktop" "Raspian-LockCam" "Raspian-Console" "Raspian-Robot"

#read -p "test" sys_type2
#until [[ $sys_type2 =~ [0-9]{1} ]]; do
#	read -p "toast" sys_type2
#	select sys_type in "Ubuntu-ML" "Ubuntu-Miner" "Ubuntu-Server" "Raspian-Desktop" "Raspian-LockCam" "Raspian-Console"
#done

do
	echo "You selected $sys_type"
	break
done
