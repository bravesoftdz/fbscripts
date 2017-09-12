#!/bin/sh
#

USERNAME=sysdba
PASSWORD=masterkey

for file in "$@"
do
    DATABASE="localhost:$file"

    echo "$timestamp  database: $file"
    /opt/firebird/bin/gfix -sweep -user $USERNAME -pa $PASSWORD $DATABASE

done

