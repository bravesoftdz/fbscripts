#!/bin/sh
#

USERNAME=sysdba
PASSWORD=masterkey
DATAPATH=$1

for file in $DATAPATH
do
    DATABASE="localhost:$file"

    echo "$timestamp  database: $file"
    /opt/firebird/bin/gfix -shut full -force 0 -user $USERNAME -pa $PASSWORD $DATABASE

done

