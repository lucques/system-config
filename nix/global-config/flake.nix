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
        nixpkgs.url   = "github:NixOS/nixpkgs/b5e12ffe521b8cb211e62e82011260b7421830ff";       # 2024-12
        nixpkgs-9.url = "github:NixOS/nixpkgs/b5e12ffe521b8cb211e62e82011260b7421830ff";       # 2024-12
        nixpkgs-8.url = "github:NixOS/nixpkgs/92847f528e7a06fd74bf9534e56cf39f4bcc5371";       # 2023-12
        nixpkgs-7.url = "github:NixOS/nixpkgs/252688892fde6cbb394b6e63e17e91b0892629f8";       # 2023-09
        nixpkgs-6.url = "github:NixOS/nixpkgs/491a731e318ed892a590e0d80be873ff2f34647d";       # 2023-07
        nixpkgs-5.url = "github:NixOS/nixpkgs/82a308407fcde838b07a1c7746dc63c811c82562";       # 2023-07
        nixpkgs-4.url = "github:NixOS/nixpkgs/18fa71bbe00d702cfd1d531adfb3ac5e2e360971";       # 2023-03
        nixpkgs-3.url = "github:NixOS/nixpkgs/c7f5909800fd2b41042f03dcdd094e45c2873999";       # 2023-02
        nixpkgs-2.url = "github:NixOS/nixpkgs/4d2b37a84fad1091b9de401eb450aae66f1a741e";       # 2022-11
        nixpkgs-1.url = "github:NixOS/nixpkgs/b6caee49dcfe12caf6f5ce07cc1461ed34b8955a";       # 2022-09

        utils.url     = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b"; # 2024-12
        home-manager = {
            url = "github:nix-community/home-manager/35b98d20ca8f4ca1f6a2c30b8a2c8bb305a36d84";  # 2024-12
            inputs.nixpkgs.follows = "nixpkgs";
        };


        ######################################
        # Local public inputs (all dummies!) #
        ######################################
        
        hm-components-pub = {
            url = github:divnix/blank; # Dummy
        };

        lukesnixutils = {
            url = github:divnix/blank; # Dummy
        };

        externaltoolbox = {
            url = github:divnix/blank; # Dummy
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.utils.follows  = "utils";
        };

        lukestoolbox = {
            url = github:divnix/blank; # Dummy
            inputs.nixpkgs.follows = "nixpkgs";
            inputs.nixpkgs-1.follows = "nixpkgs-1"; # Not needed anymore. Keep this just as a reference for the future when we need to use an old version of nixpkgs again.
            inputs.utils.follows = "utils";
            inputs.lukesnixutils.follows = "lukesnixutils";
            inputs.externaltoolbox.follows = "externaltoolbox";
        };


        ########################
        # Local private inputs #
        ########################

        hm-components-priv = {
            url = github:divnix/blank; # Dummy
        };

        lukestoolbox-priv = {
            url = github:divnix/blank; # Dummy
            inputs.nixpkgs.follows = "nixpkgs";
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
