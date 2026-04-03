#!/bin/bash

# Can URI be specific to a dbs?

URI="mongodb://localhost:27017"
# test to local /tmp
# ultimately backup to S3 bucket
# BACKUP_HOST=
BACKUP_DIR="/tmp/backups/mongodb"
DATE=$(date +"%Y-%m-%d")

mkdir -p "$BACKUP_DIR/$DATE"
mongodump --uri="$MONGO_URI" --out="$BACKUP_DIR/$DATE"

tar -czf "$BACKUP_DIR/mongo_backup_$DATE.tar.gz" -C "$BACKUP_DIR" "$DATE"

rm -rf "$BACKUP_DIR/$DATE"

echo "Backup completed: $BACKUP_DIR/mongo_backup_$DATE.tar.gz"

# Copy backup to S3
# aws s3 cp backuplocal_v2.sh s3://wizbucketforjohndanitechdemo/
# Backup completed: /tmp/backups/mongodb/mongo_backup_2026-03-24.tar.gz
BUCKET="s3://wizbucketforjohndanitechdemo/"

echo $DATE
echo $BUCKET
echo $BACKUP_DIR

cd $BACKUP_DIR
aws s3 cp mongo_backup_$DATE.tar.gz $BUCKET

# setup as crontab every 24 hours.
# Working except for cron job