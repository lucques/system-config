# Explanations

## Terminology
- **config**: This is the name of a complete system with all corresponding tools, e.g. `t470p`.
- **Activating a config**: When activating a config, e.g. `t470p`, then...  
    - Restore static config of name `t470p` in both public and private repos
    - Run Ansible playbook of name `t470p`
    - Activate home manager config of name `t470p`


## Nixpkgs repository versions
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


## Flake `lukestoolbox`
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


## Startup scripts
- There are two main scripts:
    - `.shell-login-rc`: Run when logging in (set keyboard layout etc.). Sources and thereby extends `.shell-ordinary-rc`.
    - `.shell-ordinary-rc`: Run when starting a shell (add `~/bin` to `PATH` etc.)
- Standard rc scripts:
    - `.zshrc`: Runs `.shell-ordinary-rc` + configures zsh + plugins
    - `.xsessionrc`: Gets executed instead of `.profile`, therefore runs `.shell-login-rc`
    - `.bashrc`: Runs `.shell-ordinary-rc`
    - `.profile`: Unclear when/whether executed. Keep for compatibility, runs `.shell-login-rc`.
    - `.xprofile`, `.xinitrc` never got executed


## Static dotfiles
- Every static dotfile config is stored in the `static/configs` dir as a YAML file, e.g. `t470p.yaml`, having the following structure:
    ```
    ---
    components:
    - component_a
    - component_b
    ```
- Every component is a dir in the `static/components` dir, with a `files` subdir and a `config.yaml` of the following structure:
    ```
    ---
    targets:
        thunar: /home/luk/.config/Thunar
        bashrc: /home/luk/.bashrc
    ```
- When storing, all files of a target get synchronized *to* the `files` dir.
- When restoring, all files of a target get synchronized *from* the `files` dir. 