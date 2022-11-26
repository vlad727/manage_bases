#!/bin/sh-


# Записываем информацию в лог
echo "-------------------------------------------" >> /backup_disk/backups/backup.log

# Записываем информацию в лог с секундами
echo "`date +"%Y-%m-%d_%H-%M-%S"` Start backup" >> /backup_disk/backups/backup.log

### Delete the oldest file in dir backup ###

# get oldes file ls -lt /backup_disk/backups/ | awk  '{print $9}' | tail -1
OLD_FILE=$(ls -lt /backup_disk/backups/ | awk  '{print $9}' | tail -1)

# show oldets files
echo "$OLD_FILE file will be removed"  >> /backup_disk/backups/backup.log

# remove oldes file
rm -f /backup_disk/backups/$OLD_FILE 2>&1 >> /backup_disk/backups/backup.log

### Backup files to share ###

# Делаем бекап на диск для бекапов в расшаренную папку
/usr/bin/pg_dump -U postgres  buh | pigz > /backup_disk/backups/$(date +"%Y-%m-%d_%H-%M").buh.sql.gz

# Message to backup.log about finish
echo "`date +"%Y-%m-%d_%H-%M-%S"` Finish  backup" >> /backup_disk/backups/backup.log
