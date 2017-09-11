#!/bin/sh
#

USERNAME=sysdba
PASSWORD=masterkey
DATAPATH=$1

for file in $DATAPATH
do
    DATABASE="localhost:$file"

    echo "$timestamp  database: $file
    /opt/firebird/bin/gfix -sweep -user $USERNAME -pa $PASSWORD $DATABASE

done

