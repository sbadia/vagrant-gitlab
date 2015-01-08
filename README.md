# vagrant-gitlab

This is a fork from https://github.com/mc0e/puppet-gitlab.git, which builds
gitlab from the ground up as a virtual machine using vagrant.

I want to make the gitlab specific part modular so it can be used with a puppet
build along side other configuration.

The idea is to split sbadia's project into 3 parts.

* puppet-gitlab will provide only the gitlab specific stuff
* vagrant-gitlab will provide a vagrant project which uses the above as sub-projects.

---

## Gitlab dev. env.

### Setup

After cloning this repository, you will have to

    gem install --no-ri --no-rdoc librarian-puppet puppet

or  (on jessie)

    apt-get install librarian-puppet puppet

or (on arch, with AUR)

    pacman -Syu librarian-puppet puppet

and

    librarian-puppet install

in order to add the modules that puppet-gitlab depends on to your local copy.

### Using Debian Wheezy (the default)

    vagrant up
or
    GUEST_OS=debian7 vagrant up

### Puppet logging

Providing the _logging_ environment variable you can enable puppet _verbose_ or _debug_ log levels.
Example:

    LOGGING=debug GUEST_OS=ubuntu vagrant up

## GitLab web interface
- add the ip and name to your /etc/hosts file (192.168.111.10 gitlab.localdomain.local)
- access via your browser under the hostname (e.g. http://gitlab.localdomain.local)
- **Login**: admin@local.host
- **Password**: 5iveL!fe

1. Add an ssh key to your account, or create another account
2. Create a project
3. Play !

## Contribute
Want to help - send a pull request.

