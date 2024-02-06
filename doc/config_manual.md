# Manual configuration

The following system configuration has to be done manually.

## 1. Install automation tools

### Install Nix and home-manager
1. Install Nix package manager: https://nixos.org/download.html
2. Enable experimental features in `~/.config/nix`:
    ```
    experimental-features = nix-command flakes
    ```
3. Install `home-manager` as follows:
    ```
    nix registry add flake:nixpkgs github:...       #(insert version pinned in global-config)
    nix registry add flake:home-manager github:...  #(insert version pinned in global-config)
    nix profile install home-manager
    ```

### Install Ansible
`sudo apt install ansible`

### Install python3 and fire
`sudo apt install python3 python3-fire`


## 2. Further config

### Display Manager
- Install `lightdm`
- Run `sudo dpkg-reconfigure lightdm`
- In config file `/etc/lightdm/lightdm.conf`, activate the line `autologin-user=luk` but be careful: It must be in the `[Seat:*]` section!

### i3-with-nix
- Normally, nix is activated in `/etc/zsh/zshrc` and `/etc/bash/bash.bashrc`
    - "Activation" means `. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'` 
    - Problem: When i3 is started, nix is not yet activated, therefore nix-installed software is not in the `PATH`
    - Solution: Remove these activations
- Instead, activate before starting the i3 session: 
    - The script `~/bin/i3-with-nix` is prepared to wrap the standard `i3` session, along with an ativation account
    - Copy `~/bin/i3-with-nix` to `/usr/bin/i3-with-nix` 
    - Change file permissions to 644
    - Copy `/usr/share/xsessions/i3.desktop` to `/usr/share/xsessions/i3-with-nix.desktop` and replace in the file `i3` by `i3-with-nix`

### Locales
- Run `sudo dpkg-reconfigure locales` with
- `en-US_UTF8`
- `de-DE_UTF8`

### Backlight management
- Add the following line `luk ALL = (root) NOPASSWD: /usr/bin/brightnessctl` to `/etc/sudoers`.
- Reason: Needs to be run as root.
- Script `backlight-toggle` calls this system-installed package.

### Alternatives system
- Set default browser:
    ```
    sudo update-alternatives \
    --install /usr/bin/x-www-browser x-www-browser firefox 210`
    ```

### Brother HL-L2370DN printer
- Install "Driver Install Tool" from Brother website, Version 19.08.2021 (2.2.3-1)

### Install further software from external sources
- VS Code
- Signal Messenger
- Threema
- Google Chrome
- Dropbox
- Docker
- Xournal++
- Veracrypt
- Node.js

### Oh-my-zsh
- Install by cloning repo from github