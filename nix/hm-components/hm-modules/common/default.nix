{ config, pkgs, ... }:

let
    enLocale = "en_US.utf8";
    deLocale = "de_DE.utf8";
in

{  
    home.language = {
        # English
        base = "${enLocale}";
        ctype = "${enLocale}";
        numeric = "${enLocale}";
        collate = "${enLocale}";
        messages = "${enLocale}";
        # German
        time = "${deLocale}";
        monetary = "${deLocale}";
        paper = "${deLocale}";
        name = "${deLocale}";
        address = "${deLocale}";
        telephone = "${deLocale}";
        measurement = "${deLocale}";
    };

    # Disable keyboard management via Home Manager
    home.keyboard = null;
}
