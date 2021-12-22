##############################################################
#	Скрипт для автоматического резервного копирования
#	базы данных.
#
#	Автор:	Антон Аксенов
#	URL:	anthonyaxenov.ru
#	Email:	anthonyaxenov@gmail.com
#
#	Подробности о скрипте, подготовка к работе:
#	https://anthonyaxenov.blogspot.ru/2017/05/cron-1.html
#
##############################################################
#!/bin/bash

# Данные для работы с БД
DBHOST=
DBUSER=
DBPASS=
DBNAME=
DBCHARSET="utf8"

# Даты
FMT_DT_DIR="%d-%m-%Y"       # формат даты для директорий | 19-03-2021
FMT_DT_FILE="%H%M%S-%d%m%y" # формат даты для файлов     | 082456-190321
FMT_DT_LOG="%H:%M:%S"       # формат даты для лога       | 08:24:15.168149413

# Локальное хранилище
LOCALDIR=/backup           # полный путь директории для бэкапов
LOCALPATH=$LOCALDIR/$(date +$FMT_DT_DIR)   # полный путь директории за сегодня
LOCALFILE=$LOCALPATH/$DBNAME-$(date +$FMT_DT_FILE).sql # полный путь к файлу дампа

# Облачное хранилище
CLOUDUSE=1 # Копировать ли в облако? Закомментировать строку, если не надо
CLOUDMNT=/mnt/yadisk # Точка монтирования облака относительно корня
CLOUDDIR=db_backup # Папка в облаке, куда будут лететь файлы (внутри папки CLOUDMNT, т.е. без / в начале)
CLOUDPATH=$CLOUDMNT/$CLOUDDIR/$DATE # полный путь к папке текущей даты в облаке относительно корня
CLOUDFILE=$CLOUDPATH/$DBNAME-$DATETIME.sql # полный путь к файлу дампа в облаке
CLOUDFILEGZ=$CLOUDFILE.gz # полный путь к архиву в облаке

# Путь к бекапу на примонтированном хранилище будет выглядеть так:
# /mnt/yadisk/db_backup/2017-01-01/mybigdatabase-2017-01-01-12-23-34.sql.gz

log() {
	echo "[$(date +$FMT_DT_LOG)] $*"
}

is_dir() {
    [ -d "$1" ]
}

# Начало процесса
echo "[--------------------------------[$(date +$FMT_DT_LOG)]--------------------------------]"
log $LOCALPATH
if ! is_dir $LOCALPATH; then # Если нет папки за сегодня
	sudo mkdir -p $LOCALPATH # создаём её, ошибки игнорируем
	[ $? -eq 0 ] && log "New directory: $LOCALPATH"
fi



log "Generate a database dump: '$DBNAME'..."
mysqldump \
	-q \
	--user=$DBUSER \
	--host=$DBHOST \
	--password=$DBPASS \
	--opt \
	--default-character-set=$DBCHARSET $DBNAME \
	> $LOCALFILE
exit



if [[ $? -gt 0 ]]; then
	# если дамп сделать не удалось (код завершения предыдущей команды больше нуля) - прерываем весь скрипт
	log "Dumping failed! Script aborted."
	exit 1
else # иначе - упаковываем его
	log "Dumping successfull! Packing in GZIP..."
	gzip $LOCALFILE # Упаковка
	if [[ $? -ne 0 ]]; then # Если не удалась
		log "GZipping failed! SQL-file will be uploaded."
		GZIP_FAILED=1 # Создаём флажок, что упаковка сорвалась
	else
		log "Result file: $LOCALFILEGZ"
	fi
	if [[ $CLOUDUSE -eq 1 ]]; then # Если задано копирование в облако - делаем всякое такое
		mount | grep "$CLOUDMNT" > /dev/null # Проверяем примонтировано ли уже у нас облако  (вывод не важен)
		if [[ $? -ne 0 ]]; then # Если нет
			mount $CLOUDMNT # значит монтируем
		fi
		if [[ $? -eq 0 ]]; then # если монтирование успешно - копируем туда файл
			log "Cloud: successfully mounted at $CLOUDMNT"
			log "Cloud: copying started => $CLOUDFILEGZ"
			if ! [[ -d $CLOUDPATH ]]; then # Если в облаке нет папки за сегодня
				mkdir $CLOUDPATH 2> /dev/null # создаём её, ошибки игнорируем
			fi
			if [[ -f $LOCALFILEGZ && GZIP_FAILED -ne 1 ]]; then # Если у нас архивирование выше не сорвалось
				cp -R $LOCALFILEGZ $CLOUDFILEGZ # Копируем архив
			else
				cp -R $LOCALFILE $CLOUDFILE # Иначе - копируем большой тяжёлый дамп
			fi
			if [[ $? -gt 0 ]]; then # Если не скопировался - просто сообщаем
				log "Cloud: copy failed."
			else # Если скопировался - сообщаем и размонтируем
				log "Cloud: file successfully uploaded!"
				umount $CLOUDMNT # Размонтирование облака
				if [[ $? -gt 0 ]]; then # Сообщаем результат размонтирования (если необходимо)
					log "Cloud: umount - failed!"
				fi # Конец проверки успешного РАЗмонтирования
			fi  # Конец проверки успешного копирования
		else # если монтирование НЕуспешно - сообщаем
			log "Cloud: failed to mount cloud at $CLOUDMNT"
		fi # Конец проверки успешного монтирования
	fi # Конец проверки необходимости выгрузки в облако
fi # Конец проверки успешного выполнения mysqldump
log "Stat datadir space (USED): `du -h $LOCALPATH | tail -n1`" # вывод размера папки с бэкапами за текущий день
log "Free HDD space: `df -h /home|tail -n1|awk '{print $4}'`" # вывод свободного места на локальном диске
log "All operations completed!"
exit 0 # Успешное завершение скрипта
