{
    description = ''
        Home Manager configuration for T470p
    '';

    inputs = {
        # Contains pinned external inputs
        global-config.url = path:../../global-config;

        # External
        nixpkgs.follows = "global-config/nixpkgs";
        nixpkgs-2.follows = "global-config/nixpkgs-2";
        nixpkgs-1.follows = "global-config/nixpkgs-1";
        utils.follows = "global-config/utils";
        home-manager.follows = "global-config/home-manager";

        # Local and public
        system-config-pub-hm-modules.follows = "global-config/system-config-pub-hm-modules";
        lukesnixutils.follows = "global-config/lukesnixutils";
        externaltoolbox.follows = "global-config/externaltoolbox";
        lukestoolbox.follows = "global-config/lukestoolbox";

        # Local and private
        system-config-priv-hm-modules.follows = "global-config/system-config-priv-hm-modules";
        lukestoolbox-priv.follows = "global-config/lukestoolbox-priv";        
        keyboard-us-luckey.follows = "global-config/keyboard-us-luckey";
    };

    outputs = { self, nixpkgs, lukesnixutils, home-manager, ...}@inputs:
        let
            system   = "x86_64-linux";
            username = "luk";
            
            overlayFlakes = with inputs; [externaltoolbox
                                          lukestoolbox
                                          lukestoolbox-priv
                                          keyboard-us-luckey];
            overlayPackages = {inherit lukesnixutils;};

            pkgs = lukesnixutils.lib.instantiateNixpkgs system nixpkgs overlayFlakes overlayPackages;
        in

        {
            homeConfigurations.t470p = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                modules = [
                    # Takes up the role of `home.nix`
                    (lukesnixutils.lib.mkHomeManagerBasicModule username nixpkgs.rev)
                    # Public modules
                    inputs.system-config-pub-hm-modules.nixosModules.common
                    inputs.system-config-pub-hm-modules.nixosModules.zsh
                    inputs.system-config-pub-hm-modules.nixosModules.linux-desktop
                    # Private modules
                    inputs.system-config-priv-hm-modules.nixosModules.zsh
                    inputs.system-config-priv-hm-modules.nixosModules.linux-desktop
                ];

                # HACK: This is a hack to get the nixpkgs revision into the home-manager configuration.
                # Currently not needed though.
                # extraSpecialArgs.pkgs-2 = pkgs-2;
                # extraSpecialArgs.pkgs-1 = pkgs-1;
            };
        };
}