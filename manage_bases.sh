#!/bin/bash 

# That script allows: 
# - show list of bases
# - create copy base on the same server
# - show backup files
# - unpack backup file 
# - restore base from backup file  
# ALTER DATABASE "a-b" RENAME TO adashb; # if you want to drop database with "-"
#=================================================================================================================== 
# show help info 
if [[ $# -eq 0 ]]; then
	echo -e " Скрипт для управления базами данных на сервере $HOSTNAME \n 
        Введите режим работы:	
	show_databases     отобразить список баз данных на сервере $HOSTNAME
	create_copy        создать копию базы данных
        show_backups       отобразить список бэкапов
        unpack_base        разархивировать бэкап файл 
	empty_base         создать пустую базу для будущего восстановления
	drop_base          удалить базу данных
	restore_base       восстановить базу данных из бэкапа
	rename_base        переименовать базу данных \n 
	example: ./manage_bases.sh restor_base or bash manage_bases.sh rename_base \n"

else
	echo -e " Unknown option \n please use -h or --help "
fi
#===================================================================================================================
case "$1" in
"show_databases")
	psql -U postgres -c '\l'
;;

"create_copy")
	echo "Input source base name:"
		read srcbase 
			echo "Input destination base name:" 
				read dstbase 
					echo "Source base name  $srcbase" 
						echo "Destination base name $dstbase" 
							psql -U postgres -c "CREATE DATABASE $dstbase TEMPLATE $srcbase;"
;;

"show_backups")
	echo "Размер | месяц | число | время создания бэкапа | файл бэкапа "
		ls -lh  /backup_disk/backups/ | awk '{print $5 "      " $6 "      " $7 "      " $8 "                  " $9}'
;;

"unpack_base")
	echo "Input file source name: "
                read srcfile
			echo "Unpack process may take for 15 min"
				unpigz /backup_disk/backups/$srcfile
					echo "File is unpacked!!! Run again "show_backups" to get new file name" 
;;

"empty_base")
	echo "Input name for new empty database: "
		read new_database
			psql -U  postgres -c "CREATE DATABASE -T template0 $new_database;"
				echo "Empty base has been created with name $new_database" 
;;

"drop_base")
        echo "Input name database which one do you want to drop: "
		read drop_name
			psql -U postgres -c "DROP DATABASE $drop_name;"
				echo "Base with name $drop_name has been dropped"
;;

"restore_base")
	echo "Input backup file name: "
		read file_name
			echo "Input empty base name: "
				read empty_base_name
					psql -U postgres $empty_base_name < /backup_disk/backups/$file_name
;;
esac
