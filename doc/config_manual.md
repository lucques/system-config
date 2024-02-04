# Manual configuration

The following system configuration has to be done manually.

## Display Manager
- Install `lightdm`
- Run `sudo dpkg-reconfigure lightdm`
- In config file `/etc/lightdm/lightdm.conf`, activate the line `autologin-user=luk` but be careful: It must be in the `[Seat:*]` section!

## Locales
- Run `sudo dpkg-reconfigure locales` with
- `en-US_UTF8`
- `de-DE_UTF8`

## Backlight management
- Add the following line `luk ALL = (root) NOPASSWD: /usr/bin/brightnessctl` to `/etc/sudoers`.
- Reason: Needs to be run as root.
- Script `backlight-toggle` calls this system-installed package.

## Alternatives system
- Set default browser:
    ```
    sudo update-alternatives \
    --install /usr/bin/x-www-browser x-www-browser firefox 210`
    ```

## Brother HL-L2370DN printer
- Install "Driver Install Tool" from Brother website, Version 19.08.2021 (2.2.3-1)

## Install snap
- `sudo apt install snapd`

## Install further software from external sources
- VS Code
- Spotify (snap)
- Skype (snap)
- Pinta (snap)
- duplicity (snap)

## Install Ansible
- `sudo apt install ansible`
