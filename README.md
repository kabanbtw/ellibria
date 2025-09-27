# 🦋 Ellibria - wallpaper fetcher

A lightweight Linux script to fetch and apply wallpapers based on user-defined tags. It supports previewing images in the terminal and works across various desktop environments.

![](https://github.com/kabanbtw/ellibria/blob/main/image.png)


## ✨ Features

- Search for wallpapers using tags (e.g., `anime`, `landscape`, `cat_ears`).
- Display image previews in the terminal (supports Kitty and Ghostty).
- Prompt for applying wallpapers.
- Automatically apply wallpapers based on your desktop environment (GNOME, KDE, XFCE, Cinnamon, Budgie, etc.).
- Save downloaded wallpapers to `~/Pictures/wallpapers`. 

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kabanbtw/ellibria.git
   cd ellibria
   ```

2. Make the script executable:
   ```bash
   chmod +x ellibria.sh
   ```

3. Run the script:
   ```bash
   ./ellibria.sh
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
./ellibria.sh
```
1. Enter a tag (e.g., anime ) to search for wallpapers. The script fetches and displays a random wallpaper.

2. Choose an action: y: apply the wallpaper, n: fetch another wallpaper with the same tag, t: enter a new tag to search for different wallpapers
   
3. exit: quit the script.





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

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
