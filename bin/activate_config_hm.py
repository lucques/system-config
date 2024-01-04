#!/usr/bin/env python3

import fire
import os
from pathlib import Path


def activate_config_hm(config_name, private=False, verbose=False):
    '''
    Update the lockfile of a home-manager config flake, then activate the hm-config.

    The `--private` mode searches the given `config_name` in the private repo and includes private components. The repo must sit in the parent dir of this repo.
    1. `some-path/system-config`
    2. `some-path/system-config-priv`
    If repo 2. is missing, then a warning is issued.
    '''

    # Local paths
    path_parent            = Path(os.path.realpath(__file__)).parent.parent.parent

    path_pub               = path_parent / 'system-config'      / 'nix'
    path_prv               = path_parent / 'system-config-priv' / 'nix'

    path_global_config     = path_pub / 'global-config'

    path_pub_flakes        = path_pub / 'flakes'
    path_pub_hm_configs    = path_pub / 'hm-configs'
    path_pub_hm_components = path_pub / 'hm-components'

    path_prv_flakes        = path_prv / 'flakes'
    path_prv_hm_configs    = path_prv / 'hm-configs'
    path_prv_hm_components = path_prv / 'hm-components'

    # Determine hm-config
    path_hm_config = None
    if private:
        path_hm_config = path_prv_hm_configs / config_name
    else:
        path_hm_config = path_pub_hm_configs / config_name
    assert path_hm_config.exists(), f'hm-config `{path_hm_config}` does not exist'


    #######################################
    # Determine inputs and build lockfile #
    #######################################

    nixargs = []

    # Add global config flake
    nixargs.append(f'--override-input global-config path:{path_global_config}')

    # Add public flakes
    for flake in path_pub_flakes.iterdir():
        if flake.is_dir():
            nixargs.append(f'--override-input global-config/{flake.name} path:{flake}')

    # Add public hm-components
    nixargs.append(f'--override-input global-config/hm-components-pub path:{path_pub_hm_components}')

    # Add private components
    if private:
        # Check that `system-config-priv` dir exists
        assert path_prv_flakes.exists(),        f'WARNING: {path_prv_flakes} does not exist'
        assert path_prv_hm_components.exists(), f'WARNING: {path_prv_hm_components} does not exist'

        # Add private flakes
        for flake in path_prv_flakes.iterdir():
            if flake.is_dir():
                nixargs.append(f'--override-input global-config/{flake.name} path:{flake}')

        # Add private hm-components
        nixargs.append(f'--override-input global-config/hm-components-priv path:{path_prv_hm_components}')


    #################
    # Peform update #
    #################
        
    cmd = f'nix flake update --flake {path_hm_config} {" ".join(nixargs)}{" --debug" if verbose else ""}'
    print(cmd, flush=True)
    exit_status = os.system(cmd)
    assert (exit_status >> 8) == 0

    print()
    

    ############
    # Activate #
    ############

    cmd = f'home-manager switch --flake {path_hm_config}#{config_name}{" -v" if verbose else ""}'
    print(cmd, flush=True)
    exit_status = os.system(cmd)
    assert (exit_status >> 8) == 0


########
# Main #
########

if __name__ == '__main__':
    fire.Fire(activate_config_hm)