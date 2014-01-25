# Ansible Roles

## Introduction

These are the Ansible roles that I use to provision my development machines.  They currently only support Ubuntu due to extensive use of PPAs.  I test them on Ubuntu 12.04 (Precise) and 13.10 (Saucy) on x86 and x86-64, but they should work on 12.04 or newer with a few exceptions noted below.  The [Packer](http://www.packer.io/) templates that I use to build [Vagrant](http://www.vagrantup.com/) boxes using these roles are available [here](https://github.com/tomku/packer-templates).

These roles generally reflect what I personally need for development and experimentation.  Pull requests are welcome to fix obvious bugs, but I'm not really looking for anyone else to add substantial features.

## General Notes

The 'dotfiles' role installs my (tomku's) [dotfiles](https://github.com/tomku/dotfiles).  If you aren't me, you probably won't find that role useful.

The 'mozart' package in Ubuntu is only available for i386, so the 'mozart-dev' role currently fails on 64-bit.

The [PPA](https://launchpad.net/~mizuno-as/+archive/silversearcher-ag) that I use for installing [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher) in the 'dev-utils' role  only has builds for Ubuntu 13.04 and 13.10, so it currently does not install on earlier versions of Ubuntu.  It would be entirely possible to fall back to building from source, but I haven't implemented that yet.

The [official LLVM stable packages](http://llvm.org/apt/) are (as of 1/25/2014) failing to build on Ubuntu 12.04 and 12.10.  I have no idea whether they will build correctly in the future, so for the moment that role should be considered broken on those platforms.

The 'lua-dev' role is a bit of a mess.  I'm not sure whether I'll fix it or get rid of it, since it doesn't actually do much.

Some APT pinning might be necessary to make sure that Brightbox's nginx packages don't overrule the official nginx packages if both 'ruby-dev' and nginx-sever are enabled.  That will probably be integrated as part of the 'ruby-dev' role soon.

The 'nginx-server' role installs PHP.  Expect that to be optional and defaulted off in the future.

The 'python-dev' role probably doesn't do what you'd expect, which is unfortunate.  Since I almost exclusively use [Anaconda](http://continuum.io/downloads) for my Python work rather than the system packages, this role downloads and installs a minimal Anaconda environment and installs pypy from a PPA.  Unfortunately, Anaconda only supports Python 2.6/2.7/3.3, so this does not provide the range of supported versions that I would like.  I'm looking into ways to make this role more generally useful without adding much more complexity.  The [deadsnakes PPA](https://launchpad.net/~fkrull/+archive/deadsnakes) looks promising.

The 'zero-disk' role should only be used as a final step before packaging a Vagrant image.  I would strongly advise against using it in any other situation.

The 'ansible-reload' role is something that I use for interactive playbook development using Vagrant, and probably shouldn't be baked into final images.

## Interactive Users

Several roles have optional tasks which initialize something for a particular user.  They use the variable 'interactive_user' to determine which user to operate as. Currently, the tasks only support a single interactive user per run.

### dotfiles

Every task in dotfiles requires 'interactive_user' to be set.

### haskell-dev

The 'haskell-dev' role can optionally initialize cabal's package list.  This is currently performed whenever 'interactive_user' is set.

### jvm-dev

The 'jvm-dev' role can optionally run a no-op task for lein and/or sbt to force them to install their jars, so that future invocations by that user can work without requiring a download.  This behavior is controlled by the boolean variables 'initialize_lein' and 'initialize_sbt', which default to true.

### lisp-dev

The 'lisp-dev' role can optionally install Quicklisp for a user and add Quicklisp's initialization code to the user's .sbclrc file.  This is currently performed whenever 'interactive_user' is set.

### ocaml-dev

The 'ocaml-dev' role can optionally initialize opam's package and compiler lists.  This behavior is controlled by the boolean variable 'ocaml_initialize_opam'.

### python-dev

The 'python-dev' role installs Anaconda to the home directory specified by 'interactive_user'.

## Vagrant

Some roles have special cases for when they're being run in a [Vagrant](http://www.vagrantup.com/) VM.

### nginx-server

When the interactive user is 'vagrant', this role configures the default nginx vhost to serve out of /vagrant/www/.

### uwsgi-server

When the interactive user is 'vagrant', this role configures uwsgi-emperor to look for uwsgi configuration files named /vagrant/uwsgi-\*.\*.

## Other Variables

### go-dev

The 'go_version' variable specifies which version of Go to install.

### io-dev

The 'io_version' variable specifies the version of Io to look for in the package filename.  This version may be different than the version printed out by the Io REPL.

### jvm-dev

The variables 'sbt_version', 'maven_version', 'ant_version', 'gradle_version' and 'groovy_version' specify which version of each to install.

The 'apache_mirror' variable specifies which Apache mirror to use.  The contents should be a URL from the [Apache mirror list](http://www.apache.org/mirrors/) with no project-specific component added on.  The Apache project also provides a [page](http://www.apache.org/dyn/closer.cgi) that suggests a close mirror.

### r-dev

The 'cran_mirror' variable specifies which CRAN mirror to use.  The contents should be a URL from the [CRAN mirror list](http://cran.r-project.org/mirrors.html) without any further path information added on.

### ruby-dev

The variables 'install_ruby1.8', 'install_ruby1.9.1', 'install_ruby2.0' and 'install_ruby2.1' control which versions of Ruby are installed.  Unlike most of the rest of my roles, this role supports installing multiple versions of Ruby simultaneously.  The 'default_ruby' variable should contain a bare version number (like "1.9.1" or "2.1") to set as the default /usr/bin/ruby.

As is normal for Debian/Ubuntu Ruby packages, ruby1.9.1 actually installs the newest release in the 1.9 series that is API-compatible with 1.9.1, which is currently 1.9.3.

### rust-dev

The 'rust-version' variable specifies which version of Rust to install.

## Future Plans

* Proper checks to see whether something is installed, to avoid unnecessary downloads to /tmp.
* Split the JVM role up into individual roles for each tool.
* Complete reworking of the 'python-dev' role.
* Figure out some reasonable Python/Ruby packages to preinstall.
* Roles to stand up IPython, IJulia and R Studio instances.
* Use a PPA for git to get more consistent versions.
* Split PHP into its own role.
* Add options for nightly/beta/snapshot versions as appropriate.
* Add options to change ports for servers.
* Add JRuby.
* Add MySQL/MariaDB.
* Maybe add Neo4j, ElasticSearch.
* Investigate writing custom modules to manage packages for cabal, opam, racket, julia, R.
