#!/bin/sh
#

USERNAME=sysdba
PASSWORD=masterkey

for file in "$@"
do
    DATABASE="localhost:$file"

    echo "$timestamp  database: $file"
    /opt/firebird/bin/gfix -shut full -force 0 -user $USERNAME -pa $PASSWORD $DATABASE

done

