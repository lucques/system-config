# System configuration using Nix

This repository contains the main configuration for my Linux machines (all Debian). For the configuration I use the Nix package manager together with home-manager to manage the user software.

Much software, especially the system-related parts, are not managed by Nix for now, but using NixOS at some point is a good perspective. In order not to break things *too* quickly on my production machines, I like being able to rely on good ole Debian and generally I like the idea of adding the Nix philosophy (here mainly: declarative system config) smoothly step by step.

The configuration is public in case it is of help to others. Nix and its ecosystem are wonderful tools but there are still many rough edges, so sharing the configuration may help others to get started. I myself benefited a lot from reading other people's resources. I tried to document some lessons learned and other tips, mostly for my future self but if it serves further people, then the better!

The configuration is split into three repos. See more details under "Usage".
1. This repo. Contains the main configuration flakes that bundle together the components.
2. Public repo. Contains the public components.
2. Private repo. Contains the private components.


## Usage

1. Install Nix package manager: https://nixos.org/download.html
2. Install `home-manager`: https://nix-community.github.io/home-manager/index.html
3. Clone the following repositories to some location, say `~/repos`.
    - `~/repos/system-config` (this repo)
    - `~/repos/system-config-pub` (public repo at [https://github.com/lucques/system-config-pub](https://github.com/lucques/system-config-pub))
        - Optional, but needed for activation via `--local`. See details further down.
    - `~/repos/system-config-priv` (private repo)
        - Optional, but may be needed for activation via `--local`. See details further down.
4. Go to `~/repos/bin`.
    - The script `activate-hm-config` is used to activate an hm-config.
        - If an hm-config carries the suffix `-pub-only`, it means that private components are omitted.
        - The flag `--local` means that the locally cloned repos should be used.
    - Here are four representative examples with explanations.
        - `activate-hm-config t470p-pub-only`
            - Activate the public config for my Thinkpad T470p, taken from GitHub
            - This should work right out of the box, just by cloning this very repo.
        - `activate-hm-config t470p-pub-only --local`
            - Activate the local public config for my Thinkpad T470p
            - This should work out of the box if you cloned the `system-config-pub` repo according to step 3.
        - `activate-hm-config t470p`
            - Activate the public+private config for my Thinkpad T470p, taken from GitHub.
            - This will crash, since the private repo url is just some dummy.
        - `activate-hm-config t470p --local`
            - Activate the local public+private config for my Thinkpad T470p
            - This option should only be available to me. 


## Explanations

- Directory structure
    - `bin` contains scripts that are used to activate the hm-configs
    - `global-config` is a flake whose only purpose is to pin specific versions of nixpkgs etc. 
    - `hm-configs` contains configs for home manager
    - `pub` and `priv` contain each:
        - `flakes`: Packages that are used by the hm-configs
        - `hm-modules`: HM modules that are used by the hm-configs
- Activation
    - After running a `./bin/home-manager-*-update` script, the `~/.nix-profile/bin` dir points to the installed software ("activated")
    - Underlying mechanism:
        - `./global-config` flake contains all the used flakes. Therefore running `nix flake update ./global-config` produces the lockfile.
        - `./hm-configs/*` flake merely points to the `./global-config` flake. Therefore running `nix flake ./hm-configs/*` basically copies the lockfile.
- Nixpkgs repository versions
    - Most derivations are from the nixpkgs repository.
    - The versions are declared as inputs of the machine config, each pointing to a specific commit.
    - All pinned inputs are declared in the `global-config` flake. Here the whole flake dependency DAG is tied together. Any hm-config just points to this `global-config` flake and follows its inputs.  
    - The following local version scheme is used, newest is top
        - `nixpkgs` input is the main one ("stable")
        - ...
        - `nixpkgs-7` input is version 7 etc.
        - ...
        - `nixpkgs-1` input is version 1
    - Most flakes' inputs are set to some default version...
        - `nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";`
        - `utils.url   = "github:numtide/flake-utils";`
        - ... but then get overriden in `global-config` to match the pinned versions.
- Flake `lukestoolbox`
    - `lukespylib`: Pytho package with common functions. 
    - `lukespython3`: Python interpreter
        - Contains `lukespylib` and some other modules.
        - It is used in two ways:
            1) For the scripts that are packaged into `lukestools` (see flake `lukestoolbox`)
            2) For scripts that are locally sitting somewhere, with `lukespython3` specified shebang.
        - Now the problem is with the env vars that are needed to run the interpreter.
            - GTK apps in python need some special env vars set to work properly
            - The solution is to wrap the `bin/python3` executable.
    - `lukestools`: User scripts that may use `lukespython3` as interpreter
    - `lukestools-priv`: Same, but private
- Startup apps: Configure in `xsession.nix` under `startup`


## Further manual setup

The following system configuration has to be done manually since it is done on system level, i.e. root access is needed or something does not work with system integration. The list is not complete.

- Display Manager
    - Install `lightdm`
    - Run `sudo dpkg-reconfigure lightdm`
    - Activate the line `autologin-user=luk` but be careful: It must be in the `[Seat:*]` section!
- Locales
    - Run `sudo dpkg-reconfigure locales` with
        - `en-US_UTF8`
        - `de-DE_UTF8`
- User's login shell
    - I also install the system-`zsh`, but the Nix one is more up to date so I use that one. For that:
    - Add the path of `/home/luk/.nix-profile/bin/zsh` to `/etc/shells` (not 100% sure how smart it is to add a user-level shell, worked well so far though)
    - Run `chsh` and set the new shell `/home/luk/.nix-profile/bin/zsh`
- Gnome Terminal
    - It seems like some service in the background needs to run. Not 100% sure.
    - But the used `gnome-terminal` is the Nix-managed one, also set via the `TERMINAL` env var.
- Backlight management
    - Install manually: `brightnessctl`
    - Add the following line `luk ALL = (root) NOPASSWD: /usr/bin/brightnessctl` to `/etc/sudoers`.
    - Reason: Needs to be run as root.
    - Script `backlight-toggle` calls this system-installed package.
- Screen locking
    - There is some problem with PAM integration, thus...
    - Install manually: `i3lock`
    - Then hm-managed `i3lock-wrapper` takes care of the rest.
- Thunar
    - Reason: GVFS filesystem support somehow does not work.
    - Unfortunately, the new Thunar versions may not be available then...
    - Install manually: `thunar` and `tango-icon-theme`
    - Configuration is managed via Nix though
- Autokey
    - Reason: Not yet tracked, because the config is done via GUI and it's not so clear how to best go about that.
    - Install manually: `autokey`
- VS Code
    - TODO Track with Nix?
- Alternatives system
    - Set default browser:
        ```
        sudo update-alternatives \
        --install /usr/bin/x-www-browser x-www-browser /home/luk/.nix-profile/bin/firefox 210`
        ```


## Lessons learned

Many, many lessons learned. I put down only some notes to remind myself why I took certain design decisions.

- The flake dependencies may form a DAG.
    - I did not manage to properly specify the DAG. What I tried was to define the inputs mutually recursive (of course still keeping them a DAG), but not on top-level, but on 2nd-level. Here is what I mean:
        ```
        system-config-pub = {
            url = path:/home/luk/proj/priv/system-config-pub;

            inputs.externaltoolbox.inputs.nixpkgs.follows = "nixpkgs";
            inputs.externaltoolbox.inputs.utils.follows  = "utils";

            inputs.lukestoolbox.inputs.nixpkgs.follows = "nixpkgs";
            inputs.lukestoolbox.inputs.nixpkgs-1.follows = "nixpkgs-1";
            inputs.lukestoolbox.inputs.utils.follows = "utils";
            inputs.lukestoolbox.inputs.lukesnixutils.follows = "system-config-pub/lukesnixutils";
            inputs.lukestoolbox.inputs.externaltoolbox.follows = "system-config-pub/externaltoolbox";
        };

        lukesnixutils.follows = "system-config-pub/lukesnixutils";
        externaltoolbox.follows = "system-config-pub/externaltoolbox";
        lukestoolbox.follows = "system-config-pub/lukestoolbox";
        ```
    - Did not work out. I believe the problem is related to this issue: https://github.com/NixOS/nix/issues/3602
    - So now I broke up the `system-config-pub` flake and went back to using the various flakes by themselves. This allows me to tie up the DAG on top-level, which does work. Maybe in the future setting up the input DAG gets better supported by Nix. Since the modules do not have dependencies in form of a DAG, there is instead a `system-config-pub-hm-modules` flake that contains the modules that are used in the `home-manager` config. The flakes are now loose.


## Todos

- Set up Thunar properly