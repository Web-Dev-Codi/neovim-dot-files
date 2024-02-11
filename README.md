## Install Neovim [Click Me](https://github.com/neovim/neovim/blob/master/INSTALL.md)

## Get healthy

Open `nvim` and enter the following:

```
:checkhealth

```



Install a clipboard manager to fix copy/paste issue within Neovim

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

**NOTE** make sure you have [node](https://nodejs.org/en/) installed.

## Fonts

Install a [Nerd Font](https://github.com/ronniedroid/getnf) for better Neovim Compatibility.


---

