pkgs: with pkgs;
[
    # Put all the dependencies of the various scripts here!
    {
        script = "backlight-toggle";
        # TODO: No dependency `brightnessctl` here, because `brightnessctl` needs to be run with `sudo` (fix this..), so it needs to be installed manually
        deps = [];
    }
    {
        script = "i3-thunar-toggle";
        deps = [];
        # deps = [xfce.thunar];
    }
    {
        script = "i3-thunar-spawn-term";
        deps = [];
        # deps = [xfce.thunar];
    }
    {
        script = "thunar-spawn-run";
        deps = [];
        # deps = [dmenu];
    }
    # {
    #     script = "signal";
    #     deps = [signal-desktop];
    # }
    {
        # Just for testing purposes
        script = "lukestools-diagnose";
        deps = [cowsay];
    }
]