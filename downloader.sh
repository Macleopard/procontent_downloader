#!/bin/bash

# Функция для получения URL и выполнения скачивания
download_file() {
    local url=$1

    # Отправляем запрос и сохраняем ответ
    response=$(curl --config header.txt -X GET -i "$url")

    # Извлекаем URL редиректа из ответа
    redirect_url=$(echo "$response" | grep -i "Location:" | tail -1 | awk '{print $2}' | tr -d '\r')

    # Извлекаем имя файла из URL редиректа
    filename=$(echo $redirect_url | grep -oP '([^/]+)(?=\?)')

    # Скачиваем файл, используя извлеченное имя файла
    curl --config header.txt -L -o "$filename" "$redirect_url"
}

# Проверяем, передан ли URL как аргумент командной строки
if [ "$#" -eq 1 ]; then
    download_file "$1"
else
    # Запрашиваем URL у пользователя
    echo "Please enter the URL:"
    read user_url
    download_file "$user_url"
fi
