#!/bin/bash

# Определяем язык (по умолчанию русский)
LANGUAGE=${LANG:-ru_RU}
LANGUAGE=${LANGUAGE:0:2} # Берем первые два символа (ru, en)

# Папка для обоев и лог-файл
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LOG_FILE="$HOME/.wallpaper_fetcher.log"
mkdir -p "$WALLPAPER_DIR"

# Словари с переводами
declare -A MESSAGES_ru
declare -A MESSAGES_en

MESSAGES_ru=(
    ["prompt_tag"]="Введи тег для поиска (или 'exit' для выхода): "
    ["searching"]="🔎 Ищу обои по тегу: "
    ["not_found"]="❌ Ничего не найдено по тегу "
    ["saved"]="📂 Обои сохранены: "
    ["apply_prompt"]="Применить эти обои? (y/n/t/exit): "
    ["applied"]="✅ Обои применены!"
    ["search_next"]="♻️ Ищу следующие обои по тегу "
    ["skipping"]="⏭️ Пропускаем, ищем другие..."
    ["unknown_de"]="⚠️ Не удалось определить DE. Ставь обои вручную: "
    ["missing_dependency"]="❌ Ошибка: требуется установить "
    ["download_failed"]="❌ Не удалось загрузить изображение"
    ["file_not_found"]="❌ Файл не найден: "
    ["preview_unavailable"]="ℹ️ Превью недоступно, установите kitty или viu"
    ["invalid_tag"]="❌ Тег не может быть пустым"
    ["prompt_new_tag"]="Введи новый тег для поиска: "
)

MESSAGES_en=(
    ["prompt_tag"]="Enter a tag to search (or 'exit' to quit): "
    ["searching"]="🔎 Searching for wallpapers with tag: "
    ["not_found"]="❌ No wallpapers found for tag "
    ["saved"]="📂 Wallpaper saved: "
    ["apply_prompt"]="Apply this wallpaper? (y/n/t/exit): "
    ["applied"]="✅ Wallpaper applied!"
    ["search_next"]="♻️ Searching for next wallpapers with tag "
    ["skipping"]="⏭️ Skipping, searching for others..."
    ["unknown_de"]="⚠️ Could not detect DE. Set wallpaper manually: "
    ["missing_dependency"]="❌ Error: please install "
    ["download_failed"]="❌ Failed to download image"
    ["file_not_found"]="❌ File not found: "
    ["preview_unavailable"]="ℹ️ Preview unavailable, install kitty or viu"
    ["invalid_tag"]="❌ Tag cannot be empty"
    ["prompt_new_tag"]="Enter a new tag to search: "
)

# Функция для получения переведенной строки
get_message() {
    local key=$1
    case $LANGUAGE in
        en) echo "${MESSAGES_en[$key]}" ;;
        *) echo "${MESSAGES_ru[$key]}" ;; # По умолчанию русский
    esac
}

# Проверка зависимостей
check_dependencies() {
    for cmd in curl jq; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "$(get_message 'missing_dependency')$cmd"
            exit 1
        fi
    done
}

# === ЛОГО ===
print_logo() {
cat << "EOF"
  ______ _ _ _ _          _       
 |  ____| | (_) |        (_)      
 | |__  | | |_| |__  _ __ _  __ _ 
 |  __| | | | | '_ \| '__| |/ _` |
 | |____| | | | |_) | |  | | (_| |
 |______|_|_|_|_.__/|_|  |_|\__,_| 

       🦋  Ellibria - Wallpaper Fetcher 🦋
EOF
}

# Проверка установленного DE
detect_de() {
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]'
    elif [ -n "$DESKTOP_SESSION" ]; then
        echo "$DESKTOP_SESSION" | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Установка обоев в зависимости от DE
set_wallpaper() {
    local image="$1"
    local de=$(detect_de)

    # Проверка существования файла
    if [[ ! -f "$image" ]]; then
        echo "$(get_message 'file_not_found')$image"
        return 1
    fi

    case "$de" in
        *gnome*|*cinnamon*|*unity*|*budgie*)
            gsettings set org.gnome.desktop.background picture-uri "file://$image"
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$image"
            ;;
        *kde*|*plasma*)
            plasma-apply-wallpaperimage "$image"
            ;;
        *xfce*)
            xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$image"
            ;;
        *lxqt*)
            pcmanfm-qt --set-wallpaper="$image"
            ;;
        *mate*)
            gsettings set org.mate.background picture-filename "$image"
            ;;
        *sway*|*hypr*|*i3*)
            swww img "$image" --transition-type grow --transition-duration 1
            ;;
        *)
            echo "$(get_message 'unknown_de')$image"
            ;;
    esac
}

# Проверяем зависимости
check_dependencies

# Обрабатываем аргументы командной строки
while [[ $# -gt 0 ]]; do
    case $1 in
        --lang) LANGUAGE="$2"; shift 2 ;;
        -t|--tag) TAG="$2"; shift 2 ;;
        *) shift ;;
    esac
done

# Печатаем логотип
print_logo

# Основной цикл
while true; do
    # Если тег не задан через аргумент, запрашиваем ввод
    if [[ -z "$TAG" ]]; then
        read -p "$(get_message 'prompt_tag')" TAG
    fi
    [[ "$TAG" == "exit" ]] && break

    # Проверка на пустой тег
    if [[ -z "$TAG" ]]; then
        echo "$(get_message 'invalid_tag')"
        TAG=""
        continue
    fi

    echo "$(get_message 'searching')$TAG"

    while true; do
        # Получаем случайное изображение
        URL=$(curl -s "https://wallhaven.cc/api/v1/search?q=$TAG&sorting=random" | jq -r '.data[0].path')

        if [ -z "$URL" ] || [ "$URL" == "null" ]; then
            echo "$(get_message 'not_found')'$TAG'"
            TAG=""
            break
        fi

        FILE="$WALLPAPER_DIR/$(basename "$URL")"

        # Загрузка с проверкой ошибок
        if ! curl -s -L "$URL" -o "$FILE"; then
            echo "$(get_message 'download_failed')"
            continue
        fi

        # Логирование
        echo "$(date): Downloaded $FILE for tag $TAG" >> "$LOG_FILE"

        # Показываем превью
        if command -v kitty &>/dev/null; then
            kitty +kitten icat "$FILE"
        elif command -v viu &>/dev/null; then
            viu "$FILE"
        else
            echo "$(get_message 'saved')$FILE"
            echo "$(get_message 'preview_unavailable')"
        fi

        # Спрашиваем про установку
        read -p "$(get_message 'apply_prompt')" ANSWER
        if [[ "$ANSWER" == "y" ]]; then
            set_wallpaper "$FILE"
            echo "$(get_message 'applied')"
            echo "$(get_message 'search_next')'$TAG'..."
        elif [[ "$ANSWER" == "t" ]]; then
            read -p "$(get_message 'prompt_new_tag')" TAG
            if [[ -z "$TAG" ]]; then
                echo "$(get_message 'invalid_tag')"
                continue
            fi
            echo "$(get_message 'searching')$TAG"
            continue
        elif [[ "$ANSWER" == "exit" ]]; then
            exit 0
        else
            echo "$(get_message 'skipping')"
        fi
    done
done
