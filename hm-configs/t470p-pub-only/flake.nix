{
    description = ''
        Home Manager configuration for T470p, public modules only
    '';

    inputs = {
        # Contains pinned external inputs
        global-config.url = path:../../global-config;

        # External
        nixpkgs.follows = "global-config/nixpkgs";
        nixpkgs-1.follows = "global-config/nixpkgs-1"; # Not needed anymore. Keep this just as a reference for the future when we need to use an old version of nixpkgs again.
        utils.follows = "global-config/utils";
        home-manager.follows = "global-config/home-manager";

        # Local and public
        system-config-pub-hm-modules.follows = "global-config/system-config-pub-hm-modules";
        lukesnixutils.follows = "global-config/lukesnixutils";
        externaltoolbox.follows = "global-config/externaltoolbox";
        lukestoolbox.follows = "global-config/lukestoolbox";
    };

    outputs = { self, nixpkgs, lukesnixutils, home-manager, ...}@inputs:
        let
            system   = "x86_64-linux";
            username = "luk";
            
            overlayFlakes = with inputs; [externaltoolbox
                                          lukestoolbox];
            overlayPackages = {inherit lukesnixutils;};

            pkgs = lukesnixutils.lib.instantiateNixpkgs system nixpkgs overlayFlakes overlayPackages;
        in

        {
            homeConfigurations.t470p-pub-only = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                modules = [
                    # Takes up the role of `home.nix`
                    (lukesnixutils.lib.mkHomeManagerBasicModule username nixpkgs.rev)
                    # Public modules
                    inputs.system-config-pub-hm-modules.nixosModules.common
                    inputs.system-config-pub-hm-modules.nixosModules.zsh
                    inputs.system-config-pub-hm-modules.nixosModules.linux-desktop
                ];
            };
        };
}