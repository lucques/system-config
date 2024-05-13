#!/usr/bin/env python3

import subprocess
import fire
import os
from pathlib import Path

import yaml

class SystemConfig:

    ########################
    # Restore static files #
    ########################

    @staticmethod
    def restore(config_name, *targets, private=False, verbose=False):
        '''
        Restore static files of the config called `config_name`. If `targets` are specified, only those targets will be restored.

        The `--private` mode searches the given `config_name` also in the private repo. Both the public and the private config (of the same name) are restored. The private repo must sit in the parent dir of this repo.
        1. `some-path/system-config`
        2. `some-path/system-config-priv`
        If repo 2. is missing, an error is thrown.

        The `--verbose` mode enables verbose logging.
        '''

        # Local paths
        path_parent         = Path(os.path.realpath(__file__)).parent.parent.parent

        path_pub            = path_parent / 'system-config'      / 'static'
        path_prv            = path_parent / 'system-config-priv' / 'static'

        path_pub_configs    = path_pub / 'configs'
        path_pub_components = path_pub / 'components'

        path_prv_configs    = path_prv / 'configs'
        path_prv_components = path_prv / 'components'


        ########################
        # Determine components #
        ########################

        paths_components = []

        # Public config
        path_pub_config = path_pub_configs / (config_name + '.yaml')
        # Read config as yaml file
        with open(path_pub_config, 'r') as file:
            config_data = yaml.safe_load(file)
            paths_components = [path_pub_components / component for component in config_data['components']]
        
        if private:
            # Private config
            path_priv_config = path_prv_configs / (config_name + '.yaml')
            # Read config as yaml file
            with open(path_priv_config, 'r') as file:
                config_data = yaml.safe_load(file)
                paths_components += [path_prv_components / component for component in config_data['components']]
        
        # Check that components exist
        for path_component in paths_components:
            assert path_component.exists(), f'Component `{path_component}` does not exist'
        

        ######################
        # Restore components #
        ######################

        if (targets):
            print(f'Restoring components (only for requested targets: {" ".join(targets)})...')
        else:
            print(f'Restoring components...')

        for path_component in paths_components:
            print(f'- {path_component}', flush=True)

            path_component_config = path_component / 'config.yaml'
            path_component_files  = path_component / 'files'

            
            ####################
            # Load config file #
            ####################

            config = None
            with open(path_component_config, 'r') as file:
                config = yaml.safe_load(file)


            ###########
            # Restore #
            ###########

            if (targets):
                print(f'  Restoring targets (of requested: {" ".join(targets)})...')
            else:
                print(f'  Restoring targets...')

            for target, path in config['targets'].items():
                if not targets or target in targets:
                    path = Path(path)
                    backup_path_target = Path(path_component_files) / path.relative_to(path.anchor)
                    path_to = path.parent
                    os.system(f'mkdir -p {path_to}')
                    cmd = f'rsync -a --delete {backup_path_target} {path_to}'
                    if verbose:
                        print(f'  - {target}')
                        print(f'    - from: {backup_path_target}')
                        print(f'    - to:   {path_to}')
                        print(f'    - cmd:  {cmd}')
                    else:
                        print(f'  - {target}')
                    os.system(cmd)


    ######################
    # Store static files #
    ######################

    @staticmethod
    def store(config_name, *targets, private=False, verbose=False):
        '''
        Store static files of the config called `config_name`.

        The `--private` mode searches the given `config_name` also in the private repo. Both the public and the private config (of the same name) are restored. The private repo must sit in the parent dir of this repo.
        1. `some-path/system-config`
        2. `some-path/system-config-priv`
        If repo 2. is missing, an error is thrown.

        The `--verbose` mode enables verbose logging.
        '''

        # Local paths
        path_parent         = Path(os.path.realpath(__file__)).parent.parent.parent

        path_pub            = path_parent / 'system-config'      / 'static'
        path_prv            = path_parent / 'system-config-priv' / 'static'

        path_pub_configs    = path_pub / 'configs'
        path_pub_components = path_pub / 'components'

        path_prv_configs    = path_prv / 'configs'
        path_prv_components = path_prv / 'components'


        ########################
        # Determine components #
        ########################

        paths_components = []

        # Public config
        path_pub_config = path_pub_configs / (config_name + '.yaml')
        # Read config as yaml file
        with open(path_pub_config, 'r') as file:
            config_data = yaml.safe_load(file)
            paths_components = [path_pub_components / component for component in config_data['components']]
        
        if private:
            # Private config
            path_priv_config = path_prv_configs / (config_name + '.yaml')
            # Read config as yaml file
            with open(path_priv_config, 'r') as file:
                config_data = yaml.safe_load(file)
                paths_components += [path_prv_components / component for component in config_data['components']]
        
        # Check that components exist
        for path_component in paths_components:
            assert path_component.exists(), f'Component `{path_component}` does not exist'


        ####################
        # Store components #
        ####################

        if (targets):
            print(f'Storing components (only for requested targets: {" ".join(targets)})...')
        else:
            print(f'Storing components...')

        for path_component in paths_components:
            print(f'- {path_component}', flush=True)

            path_component_config = path_component / 'config.yaml'
            path_component_files  = path_component / 'files'


            ####################
            # Load config file #
            ####################

            config = None
            with open(path_component_config, 'r') as file:
                config = yaml.safe_load(file)


            ##########
            # Backup #
            ##########

            if (targets):
                print(f'  Storing targets (of requested: {" ".join(targets)})...')
            else:
                print(f'  Storing targets...')

            for target, path in config['targets'].items():
                if not targets or target in targets:
                    path = Path(path)
                    backup_path_target = (path_component_files / path.relative_to(path.anchor)).parent
                    os.system(f'mkdir -p {backup_path_target}')
                    cmd = f'rsync -a --delete {path} {backup_path_target}'
                    if verbose:
                        print(f'  - {target}')
                        print(f'    - from: {path}')
                        print(f'    - to:   {backup_path_target}')
                        print(f'    - cmd:  {cmd}')
                    else:
                        print(f'  - {target}')

                    os.system(cmd)


    #############################
    # Activate Ansible playbook #
    #############################

    @staticmethod
    def activate_ansible(playbook_name, private=False, verbose=False):
        '''
        Run an Ansible playbook.

        The `--private` mode searches the given `playbook_name` in the private repo, giving the playbook access to both public and private ansible components. The repo must sit in the parent dir of this repo.
        1. `some-path/system-config`
        2. `some-path/system-config-priv`
        If repo 2. is missing, an error is thrown.

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
            path_playbook = path_prv_playbooks / playbook_name / 'playbook.yml'
        else:
            path_playbook = path_pub_playbooks / playbook_name / 'playbook.yml'
        assert path_playbook.exists(), f'Playbook `{path_playbook}` does not exist'


        ###################
        # Determine roles #
        ###################

        # Add public roles
        env_var_roles_path = path_pub_roles

        # Add private roles
        if private:
            # Check that dir exists
            assert path_prv_roles.exists(), f'Private roles under {path_prv_roles} do not exist'
            env_var_roles_path = f'{env_var_roles_path}:{path_prv_roles}'


        ################
        # Run playbook #
        ################
            
        cmd = f'ANSIBLE_NOCOWS=1 ANSIBLE_ROLES_PATH={env_var_roles_path} ansible-playbook -i localhost, --connection=local{" -vvv" if verbose else ""} --ask-become-pass {path_playbook}'
        print(cmd, flush=True)

        os.system(cmd)


    ######################
    # Activate hm config #
    ######################

    @staticmethod
    def activate_hm(config_name, private=False, verbose=False):
        '''
        Update the lockfile of a home-manager config flake called `config_name`, then activate the hm-config.

        The `--private` mode searches the given `config_name` in the private repo and includes both public and private components. The repo must sit in the parent dir of this repo.
        1. `some-path/system-config`
        2. `some-path/system-config-priv`
        If repo 2. is missing, an error is thrown.
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
            assert path_prv_flakes.exists(),        f'Flake dir {path_prv_flakes} does not exist'
            assert path_prv_hm_components.exists(), f'HM component dir {path_prv_hm_components} does not exist'

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

        os.system(cmd)

        print()
        

        ############
        # Activate #
        ############

        cmd = f'home-manager switch --flake {path_hm_config}#{config_name}{" -v" if verbose else ""}'
        print(cmd, flush=True)

        os.system(cmd)


    ################
    # Activate all #
    ################

    @staticmethod
    def activate(config_name, private=False, verbose=False):
        '''
        Shortcut for calling all three with the same `config_name`:
        1. `activate_ansible`
        2. `activate_hm`
        3. `activate_static`
        '''

        SystemConfig.restore(config_name, private=private, verbose=verbose)
        print()
        SystemConfig.activate_ansible(config_name, private=private, verbose=verbose)
        print()
        SystemConfig.activate_hm(config_name, private=private, verbose=verbose)


########
# Main #
########
    
if __name__ == '__main__':
    fire.Fire(SystemConfig)