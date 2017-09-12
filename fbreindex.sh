#!/bin/bash
#

FLIDXLST=/tmp/$(basename $0 .sh)_indexlst.tmp
CMNDFILE=/tmp/$(basename $0 .sh)_command.tmp
ERRORCMD=/tmp/$(basename $0 .sh)_errorcmd.tmp

USERNAME=sysdba
PASSWORD=masterkey

rm -f $ERRORCMD

for file in $@
do
    DATABASE="localhost:$file"

    printf 'SET HEADING off;\n SELECT "RDB$INDEX_NAME" FROM "RDB$INDICES" WHERE "RDB$SYSTEM_FLAG"=0 ORDER BY "RDB$INDEX_NAME";' | /opt/firebird/bin/isql -u $USERNAME -p $PASSWORD $DATABASE > $FLIDXLST

    while read dbindex
    do
        if [ -n "$dbindex" ]; then

            timestamp=`date '+%Y-%m-%d %H:%M:%S'`
            echo "$timestamp  database: $file  index: $dbindex"
            printf "ALTER INDEX \"$dbindex\" active;" > $CMNDFILE

            /opt/firebird/bin/isql -b -i "$CMNDFILE" -u $USERNAME -p $PASSWORD "$DATABASE" > $ERRORCMD 2>&1
            if [ -s $ERRORCMD ]; then
                >&2 echo "$timestamp  database: $file  index: $dbindex"
                >&2 cat $ERRORCMD
                >&2 echo "--------------------------------------------"
            fi
        fi
    done < $FLIDXLST
done

