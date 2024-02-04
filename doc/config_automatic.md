# Automatic configuration
Automatic configuration is entirely done with Ansible and Nix package manager + home-manager for now.


## Setup
1. Clone the following repositories to some location, say `~/repos`.
    - `~/repos/system-config` (this repo)
    - `~/repos/system-config-priv` (private repo)
        - Optional, needed for activation via `--private`. See details further down.
2. Install the automation tools Ansible and Nix + home-manager as instructed in [config_manual.md](config_manual.md).
3. Go to `~/repos/system-config/bin`.
    - There are three scripts
        - `activate_config_ansible.py` is used to activate an Ansible playbook.
        - `activate_config_hm.py` is used to activate an hm-config.
        - `activate_config.py` is a shortcut to activate both.
        - The flag `--private` requires the the locally cloned `system-config-priv` repo.
    - Here are two representative examples with explanations.
        - `activate_config.py t470p-pub-only`
            - Activate the public config for my Thinkpad T470p
            - This should work right out of the box, just by cloning this very repo.
        - `activate_config.py t470p --private`
            - Activate the public+private config for my Thinkpad T470p
            - This option should only be available to me. 
    - After running the `./bin/activate_config_hm.py` script, the `~/.nix-profile/bin` dir points to the installed software ("activated")


## Explanations

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
    - `.shell-login-rc`: Run when logging in (set keyboard layout etc.). Sources and thereby extends `.shell-ordinary-rc`.
    - `.shell-ordinary-rc`: Run when starting a shell (add `~/bin` to `PATH` etc.)
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
