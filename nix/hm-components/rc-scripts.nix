{
    ".shell-login-rc" = [
        {
            order = 1;
            content = ''
                PATH="$HOME/bin:$PATH"
                PATH="$HOME/.local/bin:$PATH"
                PATH="/snap/bin:$PATH"

                TERMINAL = "/usr/bin/gnome-terminal";
                #export LANG="en_US.UTF-8"
                #export LC_ALL="en_US.UTF-8"
            '';
        }
    ];

    ".shell-ordinary-rc" = [
        {
            order = 1;
            content = ''

            '';
        }
    ];

    ".zshrc" = [
        {
            order = 1;
            content = ''
                . $HOME/.shell-ordinary-rc


                export EDITOR='nano'

                # Activate opam
                [[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null


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

    # Deactivate so as not to run it twice (once in .xsessionrc and once in .profile)
    # ".profile" = [
    #     {
    #         order = 1;
    #         content = ''
    #             . $HOME/.shell-login-rc
    #         '';
    #     }
    # ];

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

