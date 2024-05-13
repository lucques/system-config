# System configuration
This repository contains the main configuration for my Linux machines (all Debian). The config components can be categorized along two axes.

1. **Manual vs. Automatic**: Some config is documented in prose and must be done "manually". I try to automate as much as possible, mainly through the use of the Nix package manager + home-manager as well as Ansible.
2. **Public vs. Private**: Most configuration is public, but some configuration I don't want to share and this is kept in a separate private repo.
3. **Store vs. Restore**: Some config must be "backupped" (*stored*) and can then later be *restored*. Some other config is simply *declared* and then applied.


## 1. Manual vs. automatic
For automation, three tools are used:
1. Ansible for...
    - Most software packages, especially GUI software. Under the hood therefore Debian's APT is used. The reason for using Ansible and not Nix is that especially GUI software works best on Debian with Debian's APT (I gave in to this realization later than I should have).
2. Nix package manager + home-manager for...
    - Some software packages, mainly command-line tools. Nix is very flexible and nixpkgs has more packages available than the Debian package repositories.
    - Custom scripts and software. Nix is great for packaging your own scripts and software.
    - Some configuration files. Many config files like rc-files etc. are managed by Nix, as it offers a great template mechanism.
3. Very simple dot-file backup utility (built-in)
    - Some configuration files. Especially those that are edited via special software, like Autokey. This approach lets me change the config manually and only when I want to commit the changes, I add them explicitly to the repo.


## 2. Public vs. private
Most of the configuration is public in case it is of help to others. Nix and its ecosystem are wonderful tools but there are still many rough edges, so sharing the configuration may help others to get started. I myself benefited a lot from reading other people's resources. I tried to document some lessons learned and other tips, mostly for my future self but if it serves further people, then the better!


## Organization
The configuration is split into two repos. See more details under "Usage".

1. This repo. Contains the public components.
2. Private repo. Contains the private components.

How are all components kept separate but are automatically mergable nonetheless?
1. Ansible roles are mergable by design.
2. Nix hm-modules are mergable by design. Some config files even consist of public and private parts, and are concatenated at build-time (using Nix).
3. Dot-files are independent anyway.


## Usage
There are two ways to use this repo:
1. Store. Add to the config. See e.g. [./doc/configs/t470p/store.md](./doc/configs/t470p/store.md)
2. Restore. Apply the config. See e.g. [./doc/configs/t470p/restore.md](./doc/configs/t470p/restore.md)


## Directory structure
Some of these dirs only exist in the private repo.

- `bin` contains scripts that are used to apply the automatic configurations
- `doc`
    - [`config_automatic.md`](./doc/config_automatic.md): Documentation of automatic config
    - [`config_manual.md`](./doc/config_manual.md): Documentation of manual config
    - log.md: Timestamp-based manually-maintained log
    - past_issues.md: Documentation of issues encountered in the past
    - todos.md: TODOs
- `ansible` anything Ansible-related
    - `playbooks` contains Ansible configs
    - `roles` contains Ansible roles (mergable by design)
- `nix` anything Nix-related
    - `hm-configs` contains home-manager configs
    - `hm-components` contains config components
        - `hm-modules` contains separate home-manager modules
    - `flakes` contains flakes of small tools
    - `global-config` is a flake whose only purpose is to pin specific versions of nixpkgs etc. 
- `static` static dotfiles
    - `components` contains bundles of dotfile paths for re-use
    - `configs` contains so-called static configurations (=bundles of components)