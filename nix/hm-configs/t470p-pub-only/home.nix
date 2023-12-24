{ config, pkgs, ... }:

let
    username = "luk";

    lukesnixutils = pkgs.lukesnixutils.lib;
    
    screenlayouts = pkgs.hm-components-pub.lib.screenlayouts;

    configFileParts = [
        (pkgs.hm-components-pub.lib.i3-config pkgs screenlayouts)
        (pkgs.hm-components-pub.lib.rc-scripts)
    ];

    configFilesContent = lukesnixutils.configFilePartsToConcatConfigFiles configFileParts;
    configFiles = builtins.mapAttrs (path: content: { source = pkgs.writeText "config" content; }) configFilesContent;
in
{
    imports = [

    ];

    home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "23.11";
        
        file = configFiles;
    };
}