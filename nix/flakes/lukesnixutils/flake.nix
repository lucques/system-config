{
    description = ''
        Some useful Nix utility functions
    '';

    inputs = { };

    outputs = { self, ... }: {
        lib = import ./.;
    };
}