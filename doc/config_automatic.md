# Automatic configuration
Automatic configuration is entirely done in Nix for now.

## Nix

### Setup
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
4. Clone the following repositories to some location, say `~/repos`.
    - `~/repos/system-config` (this repo)
    - `~/repos/system-config-priv` (private repo)
        - Optional, needed for activation via `--with-priv`. See details further down.
5. Go to `~/repos/system-config/bin`.
    - The script `activate-hm-config` is used to activate an hm-config.
        - The flag `--priv` requires the the locally cloned `system-config-priv` repo.
        - If an hm-config carries the suffix `-pub-only`, it means that no private components are needed.
    - Here are two representative examples with explanations.
        - `activate-hm-config t470p-pub-only`
            - Activate the public config for my Thinkpad T470p
            - This should work right out of the box, just by cloning this very repo.
        - `activate-hm-config t470p --priv`
            - Activate the public+private config for my Thinkpad T470p
            - This option should only be available to me. 
    - After running the `./bin/activate-hm-config` script, the `~/.nix-profile/bin` dir points to the installed software ("activated")


### Nixpkgs repository versions
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


### Flake `lukestoolbox`
- `lukespylib`: Python package with common functions. 
- `lukespython3`: Python interpreter
    - Contains `lukespylib` and some other modules.
    - It is used in two ways:
        1. For the scripts that are packaged into `lukestools` (see flake `lukestoolbox`)
        2. For scripts that are locally sitting somewhere, with `lukespython3` specified shebang.
    - Now the problem is with the env vars that are needed to run the interpreter.
        - GTK apps in python need some special env vars set to work properly
        - The solution is to wrap the `bin/python3` executable.
- `lukestools`: User scripts that may use `lukespython3` as interpreter
- `lukestools-priv`: Same, but private


### Startup scripts
- There are two main scripts:
    - `.shell-ordinary-rc`: Run when starting a shell (add `~/bin` to `PATH` etc.)
    - `.shell-login-rc`: Run when logging in (set keyboard layout etc.)
- Standard rc scripts:
    - `.zshrc`: Runs `.shell-ordinary-rc` + configures zsh + plugins
    - `.xsessionrc`: Gets executed instead of `.profile`, therefore runs `.shell-login-rc`
    - `.bashrc`: Runs `.shell-ordinary-rc`
    - `.profile`: Unclear when/whether executed. Keep for compatibility, runs `.shell-login-rc`.
    - `.xprofile`, `.xinitrc` never got executed
- Normally, nix is activated in `/etc/zsh/zshrc` and `/etc/bash/bash.bashrc`
    - "Activation" means `. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'` 
    - Problem: When i3 is started, nix is not activated
    - Therefore: Remove these activations
- Instead, activate before starting the i3 session: 
    - Copy `/usr/bin/i3-with-nix` to `/home/luk/bin/i3-with-nix`
    - Copy `/usr/share/xsessions/i3.desktop` to `i3-with-nix.desktop` to use `i3-with-nix` instead of `i3`
