{
    description = ''
        Personal toolbox of scripts and tools. This is only the public part.
        - `lukespylib` is a python3 package that provides some common helper functions.
        - `lukespython3` is a python3 environment with the `lukespylib` package included.
        - `lukestools` is a set of scripts that are used for everyday things, written in bash or python3.
    '';

    inputs = {
        # External inputs
        nixpkgs.url   = "github:NixOS/nixpkgs/nixos-22.11";
        nixpkgs-1.url = "github:NixOS/nixpkgs/nixos-22.11"; # Not needed anymore. Keep this just as a reference for the future when we need to use an old version of nixpkgs again.

        utils.url     = "github:numtide/flake-utils";

        # Public local inputs
        lukesnixutils.url = path:../lukesnixutils;
        externaltoolbox.url = path:../externaltoolbox;
    };

    outputs = { self, nixpkgs, nixpkgs-1, lukesnixutils, utils, ... }@inputs:
        utils.lib.eachDefaultSystem (system:
        let
            overlayFlakes = with inputs; [externaltoolbox];
            overlayPackages = {};

            pkgs   = lukesnixutils.lib.instantiateNixpkgs system nixpkgs   overlayFlakes overlayPackages;
            pkgs-1 = lukesnixutils.lib.instantiateNixpkgs system nixpkgs-1 overlayFlakes overlayPackages; # Not needed anymore. Keep this just as a reference for the future when we need to use an old version of nixpkgs again.

            # Python packages for `lukespython3` and `lukespython3gtk`
            commonPythonPackages = pythonPkgs: with pythonPkgs; [
                i3ipc   # bindings for i3 IPC
                fire
                pyyaml
                pillow
            ];
        in

        {
            packages = 
            {
                lukespylib =
                    pkgs.python3Packages.buildPythonPackage {
                        pname = "lukespylib";
                        version = "0.1.0";
                        src = ./lukespylib;
                        format = "pyproject";

                        buildInputs = [
                            pkgs.python3Packages.setuptools
                        ];
                    };

                lukespython3 =
                    let
                        pname = "lukespython3";
                        # Python env with the `lukespylib` package
                        pythonPackages = pythonPkgs:
                            [
                                self.packages.${system}.lukespylib  # lukespylib
                            ]
                            ++ commonPythonPackages pythonPkgs;     # common packages 
                        thePythonPkg = pkgs.python3.withPackages pythonPackages;
                    in
                        # This package is essentially a wrapper for the python env,
                        # providing the `lukespython3` executable.
                        # It also adds the GAppsHooks env vars that are needed for GTK apps.
                        pkgs.stdenv.mkDerivation {
                            inherit pname;
                            version = "0.1.0";
                            buildInputs = [
                                thePythonPkg
                            ];
                            nativeBuildInputs = [
                                # Notice: `wrapGwrapGAppsNoGuiHookAppsHook` overrides `makeWrapper` by `makeBinaryWrapper`
                                pkgs.wrapGAppsNoGuiHook         # Collect env variables and set them in the wrapper
                            ];
                            unpackPhase = "true";
                            installPhase = ''
                                mkdir -p $out/bin
                                ln -s ${thePythonPkg}/bin/python3 $out/bin/${pname}
                            '';
                        };

                lukespython3gtk =
                    let
                        pname = "lukespython3gtk";
                        # Python env with the `lukespylib` package
                        pythonPackages = pythonPkgs: with pythonPkgs;
                            [
                                self.packages.${system}.lukespylib  # lukespylib
                                pygobject3                          # bindings for GTK3
                            ]
                            ++ commonPythonPackages pythonPkgs;     # common packages
                        thePythonPkg = pkgs.python3.withPackages pythonPackages;
                    in
                        # This package is essentially a wrapper for the python env,
                        # providing the `lukespython3` executable.
                        # It also adds the GAppsHooks env vars that are needed for GTK apps.
                        pkgs.stdenv.mkDerivation {
                            inherit pname;
                            version = "0.1.0";
                            buildInputs = [
                                thePythonPkg
                            ];
                            nativeBuildInputs = [
                                pkgs.gobject-introspection # Contains a setup hook for GTK python library: GI_TYPELIB_PATH etc. gets set
                                # Notice: `wrapGAppsHook` overrides `makeWrapper` by `makeBinaryWrapper`
                                pkgs.wrapGAppsHook         # Collect env variables and set them in the wrapper
                            ];
                            unpackPhase = "true";
                            installPhase = ''
                                mkdir -p $out/bin
                                ln -s ${thePythonPkg}/bin/python3 $out/bin/${pname}
                            '';
                        };
                
                lukestools =                
                    pkgs.stdenv.mkDerivation {
                        pname = "lukestools";
                        version = "0.1.0";
                        src = ./lukestools;
                        installPhase = ''
                            mkdir -p $out/bin
                            cp $src/* $out/bin
                        '';
                    };

                default = self.packages.${system}.lukestools;
            };   
                
            devShells.default = self.packages.${system}.default;
        });
}