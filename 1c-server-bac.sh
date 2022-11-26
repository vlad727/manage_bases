#!/bin/sh


echo "Backup for base with name $1 will be created"
echo "Backup for base with name $2 will be created"

BAC_DIR=/backup_disk/backups

# Записываем информацию в лог
echo "-------------------------------------------" >> $BAC_DIR/backup.log

# Записываем информацию в лог с секундами
echo "`date +"%d-%m-%Y_%H-%M-%S"` Start backup" >> $BAC_DIR/backup.log

### Delete the oldest file in dir backup ###

# get oldes file ls -lt /backup_disk/backups/ | awk  '{print $9}' | tail -1

OLD_FILE=$(ls -lt $BAC_DIR | awk  '{print $9}' | tail -1)
OLD_FILE1=$(ls -lt $BAC_DIR | awk  '{print $9}' | tail -1)

# show oldets files
echo "$OLD_FILE file will be removed"  >> $BAC_DIR/backup.log
echo "$OLD_FILE1 file will be removed"  >> $BAC_DIR/backup.log

# remove oldes file
rm -f $BAC_DIR/$OLD_FILE 2>&1 >> $BAC_DIR/backup.log
rm -f $BAC_DIR/$OLD_FILE1 2>&1 >> $BAC_DIR/backup.log

### Backup files to share ###

# Делаем бекап на диск для бекапов
/usr/bin/pg_dump -U postgres  $1 | pigz > $BAC_DIR/$(date +"%d-%m-%Y_%H-%M").$1.sql.gz
/usr/bin/pg_dump -U postgres  $2 | pigz > $BAC_DIR/$(date +"%d-%m-%Y_%H-%M").$2.sql.gz

# Message to backup.log about finish
echo "`date +"%d-%m-%Y_%H-%M-%S"` Finish  backup" >> $BAC_DIR/backup.log
