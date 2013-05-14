# vagrant-gitlab

This is a fork from https://github.com/mc0e/puppet-gitlab.git, which builds
github from the ground up as a virtual machine using vagrant.

I want to make the github specific part modular so it can be used with a puppet
build alongsideother configuration.

The idea is to split sbadia's project into 3 parts.

* puppet-gitlab will provide only the gitlab specific stuff
* puppet-gitlab\_prerequisites will provide all the prerequisites that gitlab
  requires.  If it can be a bit modular that's good.
* vagrant-gitlab will provide a vagrant project which uses the above as sub-projects.

---

## Gitlab dev. env.

### Setup

After cloning this repository, you will have to

    git submodule init

and

    git submodule update

in order to add the modules that puppet-gitlab depends on to your local copy.

### Using Debian Wheezy (the default)

    vagrant up
or
    GUEST\_OS=debian7 vagrant up

### Using Centos 6

    GUEST\_OS=centos6 vagrant up

### Using Ubuntu Quantal Quetzal (12.10)

    GUEST\_OS=ubuntu vagrant up

### Puppet logging

Providing the _logging_ environment variable you can enable puppet _verbose_ or _debug_ log levels.
Example:

    LOGGING=debug GUEST\OS=ubuntu vagrant up

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

