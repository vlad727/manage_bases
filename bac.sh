#!/bin/sh


# Записываем информацию в лог
echo "-------------------------------------------" >> /raid1/share/backups/backup.log

# Записываем информацию в лог с секундами
echo "`date +"%Y-%m-%d_%H-%M-%S"` Start backup unf" >> /raid1/share/backups/backup.log

# Делаем бекап на диск для бекапов в расшаренную папку
/usr/bin/pg_dump -U postgres  unf | pigz > /raid1/share/backups/$(date +"%Y-%m-%d_%H-%M").unf.sql.gz

# Ждем пока сделается бэкап unf базы
sleep 300

# Записываем информацию в лог с секундами
echo "`date +"%Y-%m-%d_%H-%M-%S"` Finished backup unf" >> /raid1/share/backups/backup.log

# Записываем информацию в лог с секундами
echo "`date +"%Y-%m-%d_%H-%M-%S"` Start backup buh" >> /raid1/share/backups/backup.log

# Делаем бекап на диск для бекапов в расшаренную папку
/usr/bin/pg_dump -U postgres  buh | pigz > /raid1/share/backups/$(date +"%Y-%m-%d_%H-%M").buh.sql.gz

# Записываем информацию в лог с секундами
echo "`date +"%Y-%m-%d_%H-%M-%S"` Finished backup unf" >> /raid1/share/backups/backup.log

# Записываем информацию в лог
echo "-------------------------------------------" >> /raid1/share/backups/backup.log
