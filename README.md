# Ellibria - Wallpaper Fetcher

A lightweight Linux script to fetch and apply wallpapers based on user-defined tags. It supports previewing images in the terminal and works across various desktop environments.

## ✨ Features

- Search for wallpapers using tags (e.g., `anime`, `landscape`, `cat_ears`).
- Display image previews in the terminal (supports Kitty and Ghostty).
- Prompt for applying wallpapers.
- Automatically apply wallpapers based on your desktop environment (GNOME, KDE, XFCE, Cinnamon, Budgie, etc.).
- Save downloaded wallpapers to `~/Pictures/wallpapers`. 

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/username/wallpaper-fetcher.git
   cd wallpaper-fetcher
   ```

2. Make the script executable:
   ```bash
   chmod +x wallpaper.sh
   ```

3. Run the script:
   ```bash
   ./wallpaper.sh
   ```

## 🔧 Dependencies

- `curl`: For downloading data.
- `jq`: For parsing JSON.
- `kitty` or `ghostty`: For terminal image previews (optional).
- Desktop environment tools:
  - `gsettings`: GNOME, Cinnamon, Budgie, Unity.
  - `qdbus`: KDE Plasma.
  - `xfconf-query`: XFCE.

Install dependencies on Arch Linux:
```bash
sudo pacman -S curl jq kitty
```

## 🖼️ Usage

Run the script and follow the prompts:
```bash
./wallpaper.sh
```

1. Enter tags (e.g., `anime blonde_hair`).
2. The script fetches and displays a random wallpaper.
3. Type `y` to apply or `n` to fetch another.

## 🌍 Supported Desktop Environments

- GNOME
- KDE Plasma
- XFCE
- Cinnamon
- Budgie
- Unity

## 📂 Save Location

Wallpapers are saved to:
```bash
~/Pictures/wallpapers
```

## ⚡ FAQ

**Q: Can it be compiled into a binary like `kon`?**  
A: Yes, you can compile it using `shc` or convert it to Python and use `PyInstaller`. However, the script is lightweight, portable, and works anywhere with Bash and dependencies.

**Q: How is it different from `kon`?**  
A: Unlike `kon`, this script isn't tied to Konachan and supports any API. It’s also tailored for multiple desktop environments.

## 🖤 Author

Crafted with ❤️ for Arch Linux and other distributions, prioritizing simplicity and a beautiful desktop experience.

## 📜 License

[MIT License](LICENSE)
