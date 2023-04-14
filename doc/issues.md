# Issues

Here comes an unsorted list of issues I encountered, some I could solve, some not. I put down only some notes to remind myself of what happened.

- The flake dependencies may form a DAG instead of a tree.
    - I did not manage to properly specify the DAG. What I tried was to define the inputs mutually recursive (of course still keeping them a DAG), but not on top-level, but on 2nd-level. Here is what I mean:
        ```
        system-config-pub = {
            url = path:/home/luk/proj/priv/system-config-pub;

            inputs.externaltoolbox.inputs.nixpkgs.follows = "nixpkgs";
            inputs.externaltoolbox.inputs.utils.follows  = "utils";

            inputs.lukestoolbox.inputs.nixpkgs.follows = "nixpkgs";
            inputs.lukestoolbox.inputs.nixpkgs-1.follows = "nixpkgs-1";
            inputs.lukestoolbox.inputs.utils.follows = "utils";
            inputs.lukestoolbox.inputs.lukesnixutils.follows = "system-config-pub/lukesnixutils";
            inputs.lukestoolbox.inputs.externaltoolbox.follows = "system-config-pub/externaltoolbox";
        };

        lukesnixutils.follows = "system-config-pub/lukesnixutils";
        externaltoolbox.follows = "system-config-pub/externaltoolbox";
        lukestoolbox.follows = "system-config-pub/lukestoolbox";
        ```
    - Did not work out. I believe the problem is related to this issue: https://github.com/NixOS/nix/issues/3602
    - So now I broke up the `system-config-pub` flake and went back to using the various flakes by themselves. This allows me to tie up the DAG on top-level, which does work. Maybe in the future setting up the input DAG gets better supported by Nix. Since the modules do not have dependencies in form of a DAG, there is instead a `system-config-pub-hm-modules` flake that contains the modules that are used in the `home-manager` config. The flakes are now loose.
    - I did not get `gnome-terminal` to work properly.
        - Using the nixpkgs verion of `gnome-terminal`, this sets some environment vars.
        - One of them is `GDK_PIXBUF_MODULE_FILE`, which is set to `/nix/store/.../lib/gdk-pixbuf-2.0/2.10.0/loaders.cache`.
        - But this interferes with the GTK configuration of the system.
        - So... for now I deactivate the nixpkgs version of `gnome-terminal`. It automatically gets added to my profile though, because the home-manger module `programs.gnome-terminal` is enabled. (I believe this should not be like that).
        - So what I do is: Set the `TERMINAL` env var to `/usr/bin/gnome-terminal`. This way the `gnome-terminal` from the system is used.
    - My original bug was VS Code crashing because of some error with `gdk-pixbuf-query-loaders`, which was using some nixpkgs version of `librsvg`