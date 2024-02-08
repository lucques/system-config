# System configuration

This repository contains the main configuration for my Linux machines (all Debian). The config components can be categorized along two axes.
1. Manual vs. Automatic: Some config is documented in prose and must be done "manually". I try to automate as much as possible, mainly through the use of the Nix package manager + home-manager as well as Ansible.
2. Public vs. Private: Most configuration is public, but some configuration I don't want to share and this is kept in a separate private repo.

## 1. Manual vs. automatic
For automation, two tools are used:
- Ansible for...
    - Most software packages, especially GUI software. Under the hood therefore Debian's APT is used. The reason for using Ansible and not Nix is that especially GUI software works best on Debian with Debian's APT (I gave in to this realization later than I should have).
    - Some configuration files. The imperative nature of Ansible is a good fit for some config files: It lets me change the config manually and only when I want to commit the changes, I add them explicitly to the repo.
- Nix package manager + home-manager for...
    - Some software packages, mainly command-line tools. Nix is very flexible and nixpkgs has more packages available than the Debian package repositories.
    - Custom scripts and software. Nix is great for packaging your own scripts and software.
    - Some configuration files. Many config files like rc-files etc. are managed by Nix, as it offers a great template mechanism.

The automatic config therefore typically consists of two main components:
- Ansible playbook
- Home-manager config

## 2. Public vs. private
Most of the configuration is public in case it is of help to others. Nix and its ecosystem are wonderful tools but there are still many rough edges, so sharing the configuration may help others to get started. I myself benefited a lot from reading other people's resources. I tried to document some lessons learned and other tips, mostly for my future self but if it serves further people, then the better!

## Organization
The configuration is split into two repos. See more details under "Usage".

1. This repo. Contains the public components.
2. Private repo. Contains the private components.

How are those components kept separate but are automatically mergable nonetheless? Two short answers: a) Some components are Ansible roles (mergable by design) and some are hm-modules (mergable by design). b) Some config files even consist of public and private parts, and are concatenated at build-time (using Nix).

## Usage
In order to reproduce a system configuration, follow these steps.

1. Reproduce manual configuration
2. Reproduce automatic configuration: `./bin/activate_config.py t470p --private`

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