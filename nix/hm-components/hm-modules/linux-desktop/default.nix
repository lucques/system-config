{ config, pkgs, pkgs-6, ... }@inputs:

{
    targets.genericLinux.enable = true;

    home.packages = with pkgs; [
        # nix-direnv          # Enables the `use nix` directive in `.envrc` files
        # nix-zsh-completions # TODO does not work yet?

        lukestools
        lukespython3        # Custom python3 env
        lukespython3gtk     # Custom python3 env with gtk

        # ncdu_2 # What is this?

        # chez

        pandoc`


        # Nodejs
        # nodePackages.node2nix

        # Haskell
        #cabal2nix

        # Purescript
        #purescript
        #spago                  # Deactivated because marked as broken
        #esbuild

        # Dhall
        dhall
        pkgs-6.dhall-lsp-server  # Marked as broken in current nixpkgs revision
        dhall-json
        dhall-bash
    ];

    xdg = {
        enable = true;
        configFile = {

        };
    };

    # programs.gnome-terminal = {
    #     enable = true;   # Unfortunately, this adds `gnome-terminal` to `home.packages`. TODO: Fix this at some point.
    #     profile = {
    #         "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
    #             default = true;
    #             visibleName = "Default";
    #             audibleBell = false;
    #             boldIsBright = true;
    #             colors = {
    #                 foregroundColor = "rgb(211,211,211)";
    #                 backgroundColor = "rgb(16,16,16)";
    #                 palette = [
    #                     "rgb(46,52,54)"
    #                     "rgb(204, 0, 0)"
    #                     "rgb(78, 154, 6)"
    #                     "rgb(196, 160, 0)"
    #                     "rgb(52, 101, 164)"
    #                     "rgb(117, 80, 123)"
    #                     "rgb(6, 152, 154)" 
    #                     "rgb(211, 215, 207)"
    #                     "rgb(85, 87, 83)" 
    #                     "rgb(239, 41, 41)"
    #                     "rgb(138, 226, 52)" 
    #                     "rgb(252, 233, 79)"
    #                     "rgb(114, 159, 207)"
    #                     "rgb(173, 127, 168)"
    #                     "rgb(52, 226, 226)" 
    #                     "rgb(238, 238, 236)"
    #                 ];
    #             };
    #         };
    #     };
    # };

    programs.nushell.enable = true;

    dconf.settings = {
        # Prevent IBus from overriding keyboard settings
        "desktop/ibus/general" = {
            use-system-keyboard-layout = true;
        };
    };
}