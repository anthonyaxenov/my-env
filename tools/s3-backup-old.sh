#!/bin/bash

TTL_DAYS=1
S3="s3://......"
OLDER_THAN=$(date -d "$TTL_DAYS days ago" "+%s")
echo $OLDER_THAN
s3cmd ls -r $S3 | while read -r line; do
    FILETIME=$(echo "$line" | awk {'print $1" "$2'})
    FILETIME=$(date -d "$FILETIME" "+%s")
    echo $FILETIME - $OLDER_THAN
    if [[ $FILETIME -le $OLDER_THAN ]]; then
        FILEPATH=$(echo "$line" | awk {'print $4'})
        if [ $FILEPATH != "" ]; then
            printf 'Must delete: %s\n' $FILEPATH
            echo "s3cmd del $FILEPATH"
        fi
    fi
done
