suse-minion:
    host:        apprentice-suse-minion.mgr.suse.de
    user:        root
    passwd:      linux

    {# # Optional parameters
    port:        # The target system's ssh port number
    sudo:        # Boolean to run command via sudo
    sudo_user:   # Str: Set this to execute Salt as a sudo user other than root.
                 # This user must be in the same system group as the remote user
                 # that is used to login and is specified above. Alternatively,
                 # the user must be a super-user.
    tty:         # Boolean: Set this option to True if sudo is also set to
                 # True and requiretty is also set on the target system
    priv:        # File path to ssh private key, defaults to salt-ssh.rsa
                 # The priv can also be set to agent-forwarding to not specify
                 # a key, but use ssh agent forwarding
    priv_passwd: # Passphrase for ssh private key
    timeout:     # Number of seconds to wait for response when establishing
                 # an SSH connection
    minion_opts: # Dictionary of minion opts
    thin_dir:    # The target system's storage directory for Salt
                 # components. Defaults to /tmp/salt-<hash>.
    cmd_umask:   # umask to enforce for the salt-call command. Should be in
                 # octal (so for 0o077 in YAML you would do 0077, or 63)
    ssh_pre_flight: # Path to a script that will run before all other salt-ssh
                    # commands. Will only run the first time when the thin dir
                    # does not exist, unless --pre-flight is passed to salt-ssh
                    # command or ssh_run_pre_flight is set to true in the config
                    # Added in 3001 Release.
    ssh_pre_flight_args: # The list of arguments to pass to the script
                         # running on the minion with ssh_pre_flight.
                         # Can be specified as single string.
    set_path:    # Set the path environment variable, to ensure the expected python
                 # binary is in the salt-ssh path, when running the command.
                 # Example: '$PATH:/usr/local/bin/'. Added in 3001 Release.
    ssh_options: # List of options (as 'option=argument') to pass to ssh. #}
