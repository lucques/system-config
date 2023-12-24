# Further manual setup

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
- Install manually: `brightnessctl`
- Add the following line `luk ALL = (root) NOPASSWD: /usr/bin/brightnessctl` to `/etc/sudoers`.
- Reason: Needs to be run as root.
- Script `backlight-toggle` calls this system-installed package.

## Autokey
- Reason: Not yet tracked, because the config is done via GUI and it's not so clear how to best go about that.
- Install manually: `autokey-gtk`

## VS Code
- TODO Track with Nix?

## Alternatives system
- Set default browser:
    ```
    sudo update-alternatives \
    --install /usr/bin/x-www-browser x-www-browser firefox 210`
    ```

## Wacom Intuos S CTL-4100
- Official support: https://linuxwacom.github.io/
- Hardware should be supported out-of-the-box by modern kernel
- Install furthermore the following Debian package: `xserver-xorg-input-wacom`
- There are GUIs for Gnome / KDE, but they probably only run on these desktop envs.
- Therefore: CLI. All you need to know is documented in this great blog post https://joshuawoehlke.com/wacom-intuos-and-xsetwacom-on-ubuntu-18-04/

## Install further software