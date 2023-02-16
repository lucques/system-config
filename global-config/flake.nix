{
    description = ''
        This flake has two functions.
        1) It pins the versions of all external flakes.
        2) It takes in all local (public and private) flakes. These all have dependencies, which form a DAG. This DAG is set up in this flake.
        All this makes it very comfortable to just follow this flake's inputs. As this flake is merely followed, it has no outputs.
    '';

    inputs = {
        ###################
        # External inputs #
        ###################

        # Set the nixpkgs version here. The same version will be used for the
        # user's configuration via the registry entry.
        nixpkgs.url   = "github:NixOS/nixpkgs/c7f5909800fd2b41042f03dcdd094e45c2873999";       # 2023-02
        nixpkgs-3.url = "github:NixOS/nixpkgs/c7f5909800fd2b41042f03dcdd094e45c2873999";       # 2023-02
        nixpkgs-2.url = "github:NixOS/nixpkgs/4d2b37a84fad1091b9de401eb450aae66f1a741e";       # 2022-11
        # Use this old version for python packaging to prevent this error:
        # https://discourse.nixos.org/t/python-packages-are-not-building-modulenotfounderror-no-module-named-setuptools/22232/3
        nixpkgs-1.url = "github:NixOS/nixpkgs/b6caee49dcfe12caf6f5ce07cc1461ed34b8955a";       # 2022-09

        utils.url     = "github:numtide/flake-utils/5aed5285a952e0b949eb3ba02c12fa4fcfef535f"; # 2022-11
        home-manager = {
            url = github:nix-community/home-manager/782cb855b2f23c485011a196c593e2d7e4fce746;  # 2023-02
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.utils.follows = "utils";
        };


        ########################
        # Local inputs, public #
        ########################
        system-config-pub-hm-modules = {
            url = github:lucques/system-config-pub?dir=hm-modules;
        };

        lukesnixutils = {
            url = github:lucques/system-config-pub?dir=flakes/lukesnixutils;
        };

        externaltoolbox = {
            url = github:lucques/system-config-pub?dir=flakes/externaltoolbox;
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.utils.follows  = "utils";
        };

        lukestoolbox = {
            url = github:lucques/system-config-pub?dir=flakes/lukestoolbox;
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-1.follows = "nixpkgs-1";
            inputs.utils.follows = "utils";
            inputs.lukesnixutils.follows = "lukesnixutils";
            inputs.externaltoolbox.follows = "externaltoolbox";
        };


        #########################
        # Local inputs, private #
        #########################

        system-config-priv-hm-modules = {
            url = github:divnix/blank; # Dummy
        };

        lukestoolbox-priv = {
            url = github:divnix/blank; # Dummy
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-1.follows = "nixpkgs-1";
            inputs.utils.follows = "utils";
            inputs.lukestoolbox.follows = "lukestoolbox";
            inputs.lukesnixutils.follows = "lukesnixutils";
            inputs.externaltoolbox.follows = "externaltoolbox";
        };
        
        keyboard-us-luckey = {
            url = github:divnix/blank; # Dummy
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.utils.follows = "utils";
        };
    };

    outputs = { self, ... }: { };
}