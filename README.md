# 🚀 My Neovim Configuration

A modern Neovim configuration focused on providing a powerful and user-friendly development environment.

## ⚡️ Requirements

Before installing this configuration, ensure you have the following dependencies installed:

### Neovim

- **Linux**:

  ```bash
  # Ubuntu/Debian
  sudo apt install neovim

  # Arch Linux
  sudo pacman -S neovim

  # Fedora
  sudo dnf install neovim
  ```

- **macOS**:

  ```bash
  brew install neovim
  ```

- **Windows**:
  ```powershell
  winget install Neovim.Neovim
  # or
  scoop install neovim
  ```

For the latest version, you can build from source:

```bash
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

### System Clipboard Support

- **Linux**:

  ```bash
  # Ubuntu/Debian
  sudo apt install xclip

  # Arch Linux
  sudo pacman -S xclip

  # Fedora
  sudo dnf install xclip
  ```

### Required Dependencies

1. **Ripgrep** (for telescope.nvim fuzzy finding):

   ```bash
   # Ubuntu/Debian
   sudo apt install ripgrep

   # Arch Linux
   sudo pacman -S ripgrep

   # macOS
   brew install ripgrep

   # Windows
   winget install BurntSushi.ripgrep
   ```

2. **Python support** (for various plugins):

   ```bash
   pip install pynvim
   ```

3. **Nerd Fonts** (for icons and glyphs):

   - Download your preferred font from [Nerd Fonts](https://www.nerdfonts.com/)
   - **Linux**: Copy the font files to `~/.local/share/fonts/` and run `fc-cache -fv`
   - **macOS**: Double-click the font file to install
   - **Windows**: Right-click the font file and select "Install"

   Recommended fonts:

   - JetBrainsMono Nerd Font
   - Hack Nerd Font
   - FiraCode Nerd Font

4. **Treesitter Compilers**:

   ```bash
   # Ubuntu/Debian
   sudo apt install build-essential gcc g++

   # Arch Linux
   sudo pacman -S base-devel gcc

   # macOS
   xcode-select --install

   # Windows
   winget install GnuWin32.Make
   winget install mingw
   ```

## 🚀 Installation

1. Back up your existing Neovim configuration:

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   ```

2. Clone this repository:

   ```bash
   git clone https://github.com/Web-Dev-Codi/neovim-dot-files.git ~/.config/nvim
   ```

3. Launch Neovim:
   ```bash
   nvim
   ```
   The configuration will automatically install the package manager and plugins on first launch.

## ⚙️ Post-Installation

1. Verify health status:

   ```vim
   :checkhealth
   ```

2. Install treesitter parsers:
   ```vim
   :TSInstall all
   ```

## 🎨 Configuration Structure

```
~/.config/nvim/
├── init.lua
├── lua/
|   ├── colorschemes/
|   ├── config/
|   ├── lualine/
│   ├── plugins/
└── snippets/
├── spell/
└── README.md
```

## 🔑 Key Mappings

[Keymaps coming soon]

## 📦 Included Plugins

[Plugins list coming soon]

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📝 License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.

<!-- CONTACT -->

## Contact

Web-Dev-Codi - [Portfolio](https://webdevcodi.com) - www.webdevcodi.com

Project Link: [https://github.com/Web-Dev-Codi/neovim-dot-files](https://github.com/Web-Dev-Codi/neovim-dot-files)
