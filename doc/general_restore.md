# General: Restore

The following recipes are are generally applicable.


## Install Debian
- Debian 12 (Bookworm)
- Include Gnome, Xfce


## Install Nix and home-manager
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


## Install essential tools
- `sudo apt install python3 python3-fire`
- Install the **newest** Ansible version: [Link](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-debian)


## Apply automated config
1. Clone the following repositories to some location, say `~/repos`.
    - `~/repos/system-config` (this repo)
    - `~/repos/system-config-priv` (private repo)
        - Optional, needed for activation via `--private`. See details further down.
2. Go to `~/repos/system-config/bin`.
    - There is one script `system_config.py` with three commands.
        - `restore` is used to restore static dotfiles.
        - `store` is used to store static dotfiles.
        - `activate_ansible` is used to activate an Ansible playbook.
        - `activate_hm` is used to activate an hm-config.
        - `activate` is a shortcut to activate all three.
        - The flag `--private` requires the locally cloned `system-config-priv` repo.
    - Here are two representative examples with explanations.
        - `system_config.py activate t470p-pub-only`
            - Activate the public config for my Thinkpad T470p
            - This should work right out of the box, just by cloning this very repo.
        - `system_config.py activate t470p --private`
            - Activate the public+private config for my Thinkpad T470p
            - This option should only be available to me. 
    - After running the hm config, the `~/.nix-profile/bin` dir points to the installed software ("activated")


## Configure shell and terminal emulator
- Install `oh-my-zsh`, which will be placed automatically in `~/.oh-my-zsh`. No further plugins needed.
- Select `/bin/zsh` as standard shell using the `chsh` command
- Configure colors in `gnome-terminal`


## Configure display manager
- Install `lightdm`
- Run `sudo dpkg-reconfigure lightdm`
- In config file `/etc/lightdm/lightdm.conf`, activate the line `autologin-user=luk` but be careful: It must be in the `[Seat:*]` section!


## Install i3-with-nix
- Normally, nix is activated in `/etc/zsh/zshrc` and `/etc/bash/bash.bashrc`
    - "Activation" means `. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'` 
    - Problem: When i3 is started, nix is not yet activated, therefore nix-installed software is not in the `PATH`
    - Solution: Remove these activations
- Instead, activate before starting the i3 session:
    - The script `~/bin/i3-with-nix` is prepared to wrap the standard `i3` session, along with an ativation account
    - Copy `~/bin/i3-with-nix` to `/usr/bin/i3-with-nix` 
    - Change file permissions to 655
    - Copy `/usr/share/xsessions/i3.desktop` to `/usr/share/xsessions/i3-with-nix.desktop` and replace in the file `i3` by `i3-with-nix`


## Setup locales
- Run `sudo dpkg-reconfigure locales` with
- `en-US_UTF8`
- `de-DE_UTF8`


## Configure alternatives system
- Set default browser:
    ```
    sudo update-alternatives \
    --install /usr/bin/x-www-browser x-www-browser firefox 210`
    ```


## Configure Brother HL-L2370DN printer
- Install "Driver Install Tool" from Brother website, Version 19.08.2021 (2.2.3-1), file is `linux-brprinter-installer-2.2.3-1`
- After cartridge change, may need to delete printer on CUPS (`http://localhost:631`) and run `linux-brprinter-installer-2.2.3-1` to install the printer again


## Install further software from external sources
- VS Code
- Signal Messenger
- Threema
- Google Chrome
- Dropbox
- Docker
- Xournal++
- Veracrypt
- Node.js