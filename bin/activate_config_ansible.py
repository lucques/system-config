#!/usr/bin/env python3

import fire
import os
from pathlib import Path


def activate_config_ansible(playbook, private=False, verbose=False):
    '''
    Run an Ansible playbook.

    The `--private` mode searches the given `playbook` in the private repo and includes private components. The repo must sit in the parent dir of this repo.
    1. `some-path/system-config`
    2. `some-path/system-config-priv`
    If repo 2. is missing, then a warning is issued.

    The `--verbose` mode enables verbose logging.
    '''

    # Local paths
    path_parent        = Path(os.path.realpath(__file__)).parent.parent.parent

    path_pub           = path_parent / 'system-config'      / 'ansible'
    path_prv           = path_parent / 'system-config-priv' / 'ansible'

    path_pub_roles     = path_pub / 'roles'
    path_pub_playbooks = path_pub / 'playbooks'

    path_prv_roles     = path_prv / 'roles'
    path_prv_playbooks = path_prv / 'playbooks'

    # Determine playbook
    path_playbook = None
    if private:
        path_playbook = path_prv_playbooks / playbook / 'playbook.yml'
    else:
        path_playbook = path_pub_playbooks / playbook / 'playbook.yml'
    assert path_playbook.exists(), f'Playbook `{path_playbook}` does not exist'


    ###################
    # Determine roles #
    ###################

    # Add public roles
    env_var_roles_path = path_pub_roles

    # Add private roles
    if private:
        # Check that dir exists
        assert path_prv_roles.exists(), f'WARNING: {path_prv_roles} does not exist'
        env_var_roles_path = f'{env_var_roles_path}:{path_prv_roles}'


    ################
    # Run playbook #
    ################
        
    cmd = f'ANSIBLE_NOCOWS=1 ANSIBLE_ROLES_PATH={env_var_roles_path} ansible-playbook -i localhost, --connection=local{" -vv" if verbose else ""} --ask-become-pass {path_playbook}'
    print(cmd, flush=True)
    exit_status = os.system(cmd)
    assert (exit_status >> 8) == 0


########
# Main #
########

if __name__ == '__main__':
    fire.Fire(activate_config_ansible)