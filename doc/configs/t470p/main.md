# Config for t470p

- OS: Debian 12 (Bookworm)

- first install python3, python3-fire, ansible

# APT-managed packages
- i3
- i3lock-fancy
- galculator
- pulseaudio-utils
- flameshot
- firefox
- thunderbird
- gammastep
- feh
- zsh
- python3
    - python3-pip
    - python3-fire
- libsecret-tools (for `secret-tool`)
- ghex
- thunar
- filezilla
- meld
- gitg
- poedit
- cookiecutter
- direnv

# External deb packages
- keepasscx
- threema
- telegram-desktop
- signal-desktop
- oh-my-zsh
- code
- docker (add new package repo)
- veracrypt (external)

## Nix-managed packages
- i3-battery-popup
- dmenu
- fzf
- pandoc
- xournalpp