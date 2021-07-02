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
