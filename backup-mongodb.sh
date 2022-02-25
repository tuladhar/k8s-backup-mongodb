#!/bin/bash

set -e

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz
OPLOG_FLAG=""

if [ -n "$MONGODB_OPLOG" ]; then
	OPLOG_FLAG="--oplog"
fi

echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."

mongodump $OPLOG_FLAG \
	--archive="$ARCHIVE_NAME" \
	--gzip \
	--uri "$MONGODB_URI"

COPY_NAME=$ARCHIVE_NAME
if [ ! -z "$PASSWORD_7ZIP" ]; then
    echo "[$SCRIPT_NAME] 7Zipping with password..."
    COPY_NAME=mongodump_$(date +%Y%m%d_%H%M%S).7z
    7za a -tzip -p"$PASSWORD_7ZIP" -mem=AES256 "$COPY_NAME" "$ARCHIVE_NAME"
fi


S3_ENDPOINT_OPT=""
if [ ! -z "$S3_ENDPOINT_URL" ]; then
  S3_ENDPOINT_OPT="--endpoint-url $S3_ENDPOINT_URL"
fi

echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
aws ${S3_ENDPOINT_OPT} s3 cp "$COPY_NAME" "$BUCKET_URI/$COPY_NAME"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$COPY_NAME"
rm "$ARCHIVE_NAME" || true

echo "[$SCRIPT_NAME] Backup complete!"
