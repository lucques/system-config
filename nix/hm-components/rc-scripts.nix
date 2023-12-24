{
    ".shell-login-rc" = [
        {
            order = 1;
            content = ''
                TERMINAL = "/usr/bin/gnome-terminal";
            '';
        }
    ];

    ".shell-ordinary-rc" = [
        {
            order = 1;
            content = ''
                PATH="$HOME/bin:$PATH"
            '';
        }
    ];

    ".zshrc" = [
        {
            order = 1;
            content = ''
                . $HOME/.shell-ordinary-rc


                export EDITOR='nano'


                setopt extendedglob
                # If some globbing patterns don't match, just expand them to \'\' instead of complaining
                setopt CSH_NULL_GLOB


                export KEYTIMEOUT=1


                export ZSH="$HOME/.oh-my-zsh"

                HIST_STAMPS="dd.mm.yyyy"

                DISABLE_AUTO_UPDATE=true  # Never ask for updates

                plugins=(git fzf zsh-interactive-cd zsh-autosuggestions zsh-syntax-highlighting fasd docker docker-compose nix-zsh-completions)
            '';
        }
    ];

    ".xsessionrc" = [
        {
            order = 1;
            content = ''
                . $HOME/.shell-login-rc
            '';
        }
    ];

    ".profile" = [
        {
            order = 1;
            content = ''
                . $HOME/.shell-login-rc
            '';
        }
    ];

    ".bashrc" = [
        {
            order = 1;
            content = ''
                . $HOME/.shell-ordinary-rc
            '';
        }
    ];

    "bin/i3-with-nix" = [
        {
            order = 1;
            content = ''
                #!/usr/bin/env bash

                # Activate nix
                if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
                . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
                fi

                # Hack: Reset this var, since Nix overrides it and this causes
                # segmentation faults in some GTK apps.
                XDG_DATA_DIRS=/usr/local/share:/usr/share


                exec i3 $@
            '';
        }
    ];
}
