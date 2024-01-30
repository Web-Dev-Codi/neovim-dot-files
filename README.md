## Install Neovim

[Neovim site for installation](https://github.com/neovim/neovim/blob/master/INSTALL.md)

## Get healthy

Open `nvim` and enter the following:

```
:checkhealth
```



Install and fix copy/paste

- On mac `pbcopy` should be builtin

- On Ubuntu

  ```sh
  sudo apt install xsel # for X11
  sudo apt install wl-clipboard # for wayland
  ```

Next we need to install python support (node is optional)

- Neovim python support

  ```sh
  pip install pynvim
  ```

- Neovim node support

  ```sh
  npm i -g neovim
  ```

We will also need `ripgrep` for Telescope to work:

- Ripgrep

  ```sh
  sudo apt install ripgrep
  ```

---

**NOTE** make sure you have [node](https://nodejs.org/en/).

## Fonts

Install a "Nerd Font" for better Neovim Compatibility (Font that supports icons)

[getnf](https://github.com/ronniedroid/getnf)

**NOTE** Some are already setup as examples, remove them if you want

---

