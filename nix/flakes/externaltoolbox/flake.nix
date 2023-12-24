{
    description = "
        External software scripts packaged together.
    ";

    inputs = {
        # External inputs
        nixpkgs.url   = "github:NixOS/nixpkgs/nixos-22.11";
        utils.url     = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, utils, ... }:
        utils.lib.eachDefaultSystem (system:
            let
                pkgs = import nixpkgs { inherit system; };
            in
            {
                packages = {
                    i3lock-wrapper =
                        pkgs.stdenv.mkDerivation {
                            name = "i3lock-wrapper";
                            src = pkgs.fetchgit {
                                url = "https://github.com/ashinkarov/i3-extras/";
                                sparseCheckout = ["i3lock-wrapper"];
                                rev = "a652716cd5e68428e3cbb6cd5f64f7bec528fd72";
                                sha256 = "gLO8ecbXHY1XDCNwP3o+e4wkIfEfMn4HS7Qz3u7O+ek=";
                            };
                            installPhase = ''
                                mkdir -p $out/bin
                                cp $src/i3lock-wrapper $out/bin
                            '';
                        };
                    
                    i3-battery-popup = 
                        pkgs.stdenv.mkDerivation {
                            name = "i3-battery-popup";
                            src = pkgs.fetchgit {
                                url = "https://github.com/rjekker/i3-battery-popup";
                                rev = "d894a102a1ff95019fc59d0a19c89687d502cd1a";
                                sha256 = "bqOVnqGFZsGTqy4XuYsmlUDm3MWryxcZsmHKtGkV1Ys=";
                            };
                            installPhase = ''
                                mkdir -p $out
                                cp $src/i3-battery-popup* $out
                            '';
                        };
                };               
            });
}