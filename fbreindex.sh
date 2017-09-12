#!/bin/sh
#

FLIDXLST=/tmp/idxlst.tmp

USERNAME=sysdba
PASSWORD=masterkey

for file in "$@"
do
    DATABASE="localhost:$file"

    printf 'SET HEADING off;\n SELECT "RDB$INDEX_NAME" FROM "RDB$INDICES" WHERE "RDB$SYSTEM_FLAG"=0 ORDER BY "RDB$INDEX_NAME";' | /opt/firebird/bin/isql -u $USERNAME -p $PASSWORD $DATABASE > $FLIDXLST

    while read dbindex
    do
        if [ -n "$dbindex" ]; then
            timestamp=`date '+%Y-%m-%d %H:%M:%S'`
            echo "$timestamp  database: $file  index: $dbindex"
            printf "ALTER INDEX \"$dbindex\" active;" | /opt/firebird/bin/isql -u $USERNAME -p $PASSWORD $DATABASE
        fi
    done < $FLIDXLST

done
