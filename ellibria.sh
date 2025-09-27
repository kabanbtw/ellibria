#!/bin/bash

# Папка для обоев
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLPAPER_DIR"

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
            echo "⚠️ Не удалось определить DE. Ставь обои вручную: $image"
            ;;
    esac
}

# Печатаем логотип
print_logo

# Основной цикл
while true; do
    read -p "Введи тег для поиска (или 'exit' для выхода): " TAG
    [[ "$TAG" == "exit" ]] && break

    echo "🔎 Ищу обои по тегу: $TAG"

    while true; do
        # Получаем случайное изображение
        URL=$(curl -s "https://wallhaven.cc/api/v1/search?q=$TAG&sorting=random" | jq -r '.data[0].path')

        if [ -z "$URL" ] || [ "$URL" == "null" ]; then
            echo "❌ Ничего не найдено по тегу '$TAG'"
            break
        fi

        FILE="$WALLPAPER_DIR/$(basename "$URL")"
        curl -s -L "$URL" -o "$FILE"

        # Показываем превью (ghostty/kitty поддерживают картинки)
        if command -v kitty &>/dev/null; then
            kitty +kitten icat "$FILE"
        elif command -v viu &>/dev/null; then
            viu "$FILE"
        else
            echo "📂 Обои сохранены: $FILE"
        fi

        # Спрашиваем про установку
        read -p "Применить эти обои? (y/n/exit): " ANSWER
        if [[ "$ANSWER" == "y" ]]; then
            set_wallpaper "$FILE"
            echo "✅ Обои применены!"
            echo "♻️  Ищу следующие обои по тегу '$TAG'..."
        elif [[ "$ANSWER" == "exit" ]]; then
            exit 0
        else
            echo "⏭️ Пропускаем, ищем другие..."
        fi
    done
done
