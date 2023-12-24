let
    # Parameters:
    # - `system` (string): The system to use
    # - `flakes` (list of flakes): The flakes to use
    # Returns the list of packages
    collectPackagesFromFlakeInputs = system: flakes:
        builtins.foldl' (acc: flake: acc // (removeAttrs flake.packages.${system} ["default"])) {} flakes;

    # Parameters:
    # - `system` (string): The system to use
    # - `nixpkgs` (derivation): The nixpkgs drv
    # - `overlayFlakes`   (list of flakes):  The flakes whose packages to use in overlay
    # - `overlayPackages` (set of packages): Packages to use in overlay
    # Returns the nixpkgs derivation with the overlays applied
    instantiateNixpkgs = system: nixpkgs: overlayFlakes: overlayPackages:
        let
            allOverlayPackages = (collectPackagesFromFlakeInputs system overlayFlakes)
                                 // overlayPackages;
        in
        import nixpkgs
        {
            inherit system;
            config.allowUnfree = true;
            overlays = [ (self: super: allOverlayPackages) ];
        };

    # Creates a home-manager module that configures the nix registry to use the given nixpkgs revision
    # Parameters
    # - `rev`      (string) nixpkgs revision
    # Returns home-manager module
    mkHomeManagerBasicModule = rev: moduleInputs:
    {
        nix.registry.nixpkgs = {
            from = {
                type = "indirect";
                id = "nixpkgs";
            };
            to = {
                type = "github";
                owner = "NixOS";
                repo = "nixpkgs";
                inherit rev;
            };
        };
    };

    # Parameters:
    # - `orderAttr` (string): The name of the attribute to use for ordering
    # - `contentAttr` (string): The name of the attribute to use for the content
    # - `sep` (string): The separator to use between the content
    # - `list` (list of pairs): e.g. `[(2, "ab"), (1, "cd")]`
    # Returns concatenated string, e.g. "cdab"
    glueOrderedContent = orderAttr: contentAttr: sep: list:
        let
            # Sort the list based on the 'orderAttr' attribute
            sorted = builtins.sort (a: b: builtins.getAttr orderAttr a < builtins.getAttr orderAttr b) list;
        in 
            builtins.concatStringsSep sep (map (pair: builtins.getAttr contentAttr pair) sorted);

    # Parameters:
    # - `configFiles` (list of pairs): e.g.
    #     ```
    #     [
    #       {
    #         ".zshrc" = [
    #             {
    #               order = 2;
    #               content = "test"
    #             }
    #             ...
    #         ];
    #         ".bashrc" = ...
    #       }
    #     ]
    #     ```
    # Returns a set of strings, e.g.
    #     ```
    #     {
    #       ".zshrc" = "test\n...";
    #       ".bashrc" = ...
    #     }
    #     ```
    configFilePartsToConcatConfigFiles = configFiles: 
        builtins.zipAttrsWith (name: parts:
            glueOrderedContent "order" "content" "\n" (builtins.concatLists parts)
        )
        configFiles;

    # Can be used e.g. to sym-link from `custom_python3` to some executable `.../python3`
    # Parameters:
    # - `path` (string): The path to the executable
    # - `name` (string): The name of the executable
    symlinkToBin = pkgs: path: name:
        pkgs.runCommand name {} ''
            mkdir -p $out/bin
            ln -s ${path} $out/bin/${name}
        '';
in
{
    inherit
        collectPackagesFromFlakeInputs
        instantiateNixpkgs
        mkHomeManagerBasicModule
        configFilePartsToConcatConfigFiles
        symlinkToBin;
}