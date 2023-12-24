{
    description = "
        Flake for public hm components
    ";

    inputs = { };

    outputs = { self, ... }: {
        nixosModules.common = import ./hm-modules/common;
        nixosModules.linux-desktop = import ./hm-modules/linux-desktop;
        lib.i3-config = import ./i3-config.nix;
        lib.rc-scripts = import ./rc-scripts.nix;
        lib.screenlayouts = import ./screenlayouts;
    };
}