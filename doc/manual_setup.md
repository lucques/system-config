# Further manual setup

The following system configuration has to be done manually since it is done on system level, i.e. root access is needed or something does not work with system integration. The list is not complete.

## Display Manager
- Install `lightdm`
- Run `sudo dpkg-reconfigure lightdm`
- Activate the line `autologin-user=luk` but be careful: It must be in the `[Seat:*]` section!

## Locales
- Run `sudo dpkg-reconfigure locales` with
- `en-US_UTF8`
- `de-DE_UTF8`

## User's login shell
- I also install the system-`zsh`, but the Nix one is more up to date so I use that one. For that:
- Add the path of `/home/luk/.nix-profile/bin/zsh` to `/etc/shells` (not 100% sure how smart it is to add a user-level shell, worked well so far though)
- Run `chsh` and set the new shell `/home/luk/.nix-profile/bin/zsh`

## Gnome Terminal
- It seems like some service in the background needs to run. Not 100% sure.
- But the used `gnome-terminal` is the Nix-managed one, also set via the `TERMINAL` env var.

## Backlight management
- Install manually: `brightnessctl`
- Add the following line `luk ALL = (root) NOPASSWD: /usr/bin/brightnessctl` to `/etc/sudoers`.
- Reason: Needs to be run as root.
- Script `backlight-toggle` calls this system-installed package.

## Screen locking
- There is some problem with PAM integration, thus...
- Install manually: `i3lock`
- Then hm-managed `i3lock-wrapper` takes care of the rest.

## Thunar
- Reason: GVFS filesystem support somehow does not work.
- Unfortunately, the new Thunar versions may not be available then...
- Install manually: `thunar` and `tango-icon-theme`
- Configuration is managed via Nix though

## Autokey
- Reason: Not yet tracked, because the config is done via GUI and it's not so clear how to best go about that.
- Install manually: `autokey`

## VS Code
- TODO Track with Nix?

## Alternatives system
- Set default browser:
    ```
    sudo update-alternatives \
    --install /usr/bin/x-www-browser x-www-browser /home/luk/.nix-profile/bin/firefox 210`
    ```

## Wacom Intuos S CTL-4100
- Official support: https://linuxwacom.github.io/
- Hardware should be supported out-of-the-box by modern kernel
- Install furthermore the following Debian package: `xserver-xorg-input-wacom`
- There are GUIs for Gnome / KDE, but they probably only run on these desktop envs.
- Therefore: CLI. All you need to know is documented in this great blog post https://joshuawoehlke.com/wacom-intuos-and-xsetwacom-on-ubuntu-18-04/