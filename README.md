# System configuration

This repository contains the main configuration for my Linux machines (all Debian). The config components can be sorted along two axes.
1. Manual vs. Automatic: Some config is documented in prose and must be done "manually". I try to automate as much as possible, mainly through the use of the Nix package manager together with home-manager.
2. Public vs. Private: Most configuration is public, but some configuration I don't want to share and this is kept in a separate private repo.

## Manual vs. automatic
Most software is managed by Debian's APT, including most GUI software. Some software is managed by Nix, mainly command-line tools. The reason for this separation is their incompatibility -- GUI software often depends on each other, and the Nix-installed software then is not compatible with the APT-installed GUI backends.

Nix is used for many configuration files. APT-managed software therefore uses Nix-managed config files. Using Nix for config files is great as it offers a great template mechanism.

## Public vs. private
Most of the configuration is public in case it is of help to others. Nix and its ecosystem are wonderful tools but there are still many rough edges, so sharing the configuration may help others to get started. I myself benefited a lot from reading other people's resources. I tried to document some lessons learned and other tips, mostly for my future self but if it serves further people, then the better!

## Organization
The configuration is split into two repos. See more details under "Usage".
1. This repo. Contains the public components.
2. Private repo. Contains the private components.
How are those components kept separate but are automatically mergable nonetheless? Two short answers: a) Some components are hm-modules and these are mergable by design. b) Some config files consist of public and private parts, and are concatenated at build-time.

## Usage
In order to reproduce a system configuration, follow these steps.

1. Reproduce manual configuration
2. Reproduce automatic configuration

## Directory structure
- `bin` contains scripts that are used to activate the hm-configs
- `doc`
    - [`config_automatic.md`](./doc/config_automatic.md): Automatic (i.e., Nix-based) documentation
    - [`config_manual.md`](./doc/config_manual.md): Manual documentation
    - [`general_log.md`](./doc/general_log.md): Timestamp-based log
    - [`past_issues.md`](./doc/past_issues.md): Documentation of issues encountered in the past
    - [`todos.md`](./doc/todos.md): TODOs
- `nix` anything Nix-related
    - `flakes` contains flakes of small tools
    - `global-config` is a flake whose only purpose is to pin specific versions of nixpkgs etc. 
    - `hm-components` contains automatic config components
        - `hm-modules` contains separate home-manager modules
    - `hm-configs` contains home-manager configs