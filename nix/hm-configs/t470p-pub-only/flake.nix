{
    description = ''
        Home Manager configuration for T470p, public components only
    '';

    inputs = {
        # Contains pinned external inputs
        global-config.url = path:../../global-config;

        # External
        nixpkgs.follows = "global-config/nixpkgs";
        nixpkgs-6.follows = "global-config/nixpkgs-6"; # Provide access to an older nixpkgs revision
        utils.follows = "global-config/utils";
        home-manager.follows = "global-config/home-manager";

        # Public
        hm-components-pub.follows = "global-config/hm-components-pub";
        lukesnixutils.follows = "global-config/lukesnixutils";
        externaltoolbox.follows = "global-config/externaltoolbox";
        lukestoolbox.follows = "global-config/lukestoolbox";
    };

    outputs = { self, nixpkgs, nixpkgs-6, lukesnixutils, home-manager, ...}@inputs:
        let
            system = "x86_64-linux";
            
            overlayFlakes = with inputs; [externaltoolbox
                                          lukestoolbox];
            overlayPackages = {inherit lukesnixutils;
                               inherit (inputs) hm-components-pub;};

            pkgs   = lukesnixutils.lib.instantiateNixpkgs system nixpkgs   overlayFlakes overlayPackages;
            pkgs-6 = lukesnixutils.lib.instantiateNixpkgs system nixpkgs-6 overlayFlakes overlayPackages;
        in

        {
            homeConfigurations.t470p-pub-only = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                modules = [
                    # Takes up the role of `home.nix`
                    (lukesnixutils.lib.mkHomeManagerBasicModule nixpkgs.rev)
                    ./home.nix

                    # Public modules
                    inputs.hm-components-pub.nixosModules.common
                    inputs.hm-components-pub.nixosModules.linux-desktop
                ];

                # HACK: This is a hack to get an older nixpkgs revision into the home-manager configuration.
                extraSpecialArgs.pkgs-6 = pkgs-6;
            };
        };
}