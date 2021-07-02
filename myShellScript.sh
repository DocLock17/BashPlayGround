#!/usr/bin/env bash

myVariable="lines"

echo -n "no newline"; echo -n " between these "; echo $myVariable
decalre -r myReadOnlyVar="This Variable is Read-Only"
echo $myReadOnlyVar

while read f
        do echo $f
done < myShellScript.sh
