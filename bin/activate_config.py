#!/usr/bin/env python3

import fire
from activate_config_ansible import activate_config_ansible
from activate_config_hm      import activate_config_hm


def activate_config(config_name, private=False, verbose=False):
    '''
    Run an Ansible configuration followed by a home-manager config, both of which go by the same name.

    The `--private` mode searches the given configs in the private repo and includes private components. The repo must sit in the parent dir of this repo.
    1. `some-path/system-config`
    2. `some-path/system-config-priv`
    If repo 2. is missing, then a warning is issued.

    The `--verbose` mode enables verbose logging.
    '''

    activate_config_ansible(config_name, private, verbose)
    print()
    activate_config_hm(config_name, private, verbose)


########
# Main #
########

if __name__ == '__main__':
    fire.Fire(activate_config)