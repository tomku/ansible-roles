# Ansible Roles

## Introduction

These are the Ansible roles that I use to provision my development machines.  They currently only support Ubuntu due to extensive use of PPAs.  I test them on Ubuntu 12.04 (Precise) and 14.04 (Trusty) on x86 and x86-64, but they should generally work on on the most current Ubuntu release and the last two LTSs.  The [Packer](http://www.packer.io/) templates that I use to build [Vagrant](http://www.vagrantup.com/) boxes using these roles are available [here](https://github.com/tomku/packer-templates).

These roles generally reflect what I personally need for development and experimentation.  Pull requests are welcome to fix obvious bugs, but I'm not really looking for anyone else to add substantial features.

## General Notes

The 'dotfiles' role installs my (tomku's) [dotfiles](https://github.com/tomku/dotfiles).  If you aren't me, you probably won't find that role useful.

The 'mozart' package in Ubuntu is only available for i386, so the 'mozart-dev' role currently fails on 64-bit.

The [PPA](https://launchpad.net/~mizuno-as/+archive/silversearcher-ag) that I use for installing [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher) in the 'dev-utils' role only has builds for Ubuntu 14.04, so it currently does not install on earlier versions of Ubuntu.  It would be entirely possible to fall back to building from source, but I haven't implemented that yet.

The 'lua-dev' role is a bit of a mess.  I'm not sure whether I'll fix it or get rid of it, since it doesn't actually do much.

Some APT pinning might be necessary to make sure that Brightbox's nginx packages don't overrule the official nginx packages if both 'ruby-dev' and nginx-sever are enabled.  That will probably be integrated as part of the 'ruby-dev' role soon.

The 'nginx-server' role installs PHP.  Expect that to be optional and defaulted off in the future.

The 'python-dev' role probably doesn't do what you'd expect, which is unfortunate.  Since I almost exclusively use [Anaconda](http://continuum.io/downloads) for my Python work rather than the system packages, this role downloads and installs a minimal Anaconda environment and installs pypy from a PPA.  Unfortunately, Anaconda only supports Python 2.6/2.7/3.3, so this does not provide the range of supported versions that I would like.  I'm looking into ways to make this role more generally useful without adding much more complexity.  The [deadsnakes PPA](https://launchpad.net/~fkrull/+archive/deadsnakes) looks promising.

The 'zero-disk' role should only be used as a final step before packaging a Vagrant image.  I would strongly advise against using it in any other situation.

## Interactive Users

Several roles have optional tasks which initialize something for a particular user.  They use the variable `interactive_user` to determine which user to operate as. Currently, the tasks only support a single interactive user per run.

### clojure-dev
The 'clojure-dev' role can optionally run a no-op task for lein to force it to install its jars, so that future invocations by that user can work without requiring a download.  This behavior is controlled by the boolean variable `initialize_lein`, which default to true when an interactive user is defined.

### dotfiles

Every task in dotfiles requires `interactive_user` to be set.

### haskell-dev

The 'haskell-dev' role can optionally initialize cabal's package list.  This is currently performed whenever `interactive_user` is set.

### lisp-dev

The 'lisp-dev' role can optionally install Quicklisp for a user and add Quicklisp's initialization code to the user's .sbclrc file.  This is currently performed whenever `interactive_user` is set.

### ocaml-dev

The 'ocaml-dev' role can optionally initialize opam's package and compiler lists.  This behavior is controlled by the boolean variable `ocaml_initialize_opam`.

### python-dev

The 'python-dev' role installs Anaconda to the home directory specified by `interactive_user`.

### scala-dev

The 'scala-dev' role can optionally run a no-op task for sbt to force it to install its jars, so that future invocations by that user can work without requiring a download.  This behavior is controlled by the boolean variable `initialize_sbt`, which default to true when an interactive user is defined.

## Vagrant

Some roles have special cases for when they're being run in a [Vagrant](http://www.vagrantup.com/) VM.

### nginx-server

When the interactive user is `vagrant`, this role configures the default nginx vhost to serve out of `/vagrant/www/`.

### rstudio-server

When the interactive user is `vagrant`, this role configures RStudio Server to default new sessions to starting in `/vagrant`.

### uwsgi-server

When the interactive user is `vagrant`, this role configures uwsgi-emperor to look for uwsgi configuration files named `/vagrant/uwsgi-*.*`.

## Apache Mirrors

The roles listed below download packages or archives from Apache mirrors.  The specific mirror can be set by the `apache_mirror` variable.  The contents should be a URL from the [Apache mirror list](http://www.apache.org/mirrors/) with no project-specific component added on.  The Apache project also provides a [page](http://www.apache.org/dyn/closer.cgi) that suggests a close mirror.

- couchdb
- java-dev (Maven, Ant)

## Versions

The following roles allow a particular version to be chosen for installation by setting the appropriate variable.  Version numbers should always be quoted in YAML because they may not be legal floating point numbers.

- couchdb: `couchdb_version` (Only when building from source)
- d-dev: `dmd_version` (See note below)
- elasticsearch-server: `elasticsearch_version`
- elixir-dev: `elixir_version`
- go-dev: `go_version`
- groovy-dev: `groovy_version`
- io-dev: `io_version` (From package filename, may not match REPL version)
- java-dev: `maven_version`, `ant_version` and `gradle_version`
- jruby-dev: `jruby_version`
- nginx: `nginx_branch` (`stable` or `development`)
- nodejs-dev: `node_branch` (`node_0.10`, `node_0.12`, `iojs_2.x`, `iojs_3.x`, etc
- oracle-jdk: `jdk_version` (Major version only)
- packer: `packer_version`
- rabbitmq-server: `rabbitmq_version` (Optional, default is to use latest from PPA)
- rstudio-server: `rstudio_version`
- ruby-dev: `ruby_version` (1.8, 1.9.1, 2.0 or 2.1)
- serf-agent: `serf_version`
- vagrant: `vagrant_version`
- virtualbox: `virtualbox_version` (Major and minor version only)

## Other Variables

### couchdb-server

The `couchdb_source_install` boolean variable controls whether CouchDB is installed via a PPA or from a source tarball.  The default is to use the PPA.

### d-dev

The `dmd_version` variable specifies which version of the D compiler to install, and the `dmd_year` version needs to match the year in which that version was released.  This is unfortunately necessary because D's download URLs contain the year, and even if I asked you to put in the full URL instead, I would still need the version specified so Ansible can know whether the proper version is already installed.

### erlang-dev

The `erlang_use_hipe` boolean variable determines whether or not Erlang packages with HiPE (High-Performance Erlang, a native-code compiler) are installed.

### oracle-jdk

The variable `accepted_oracle_license` reflects whether you've accepted the [Java SE license](http://www.oracle.com/technetwork/java/javase/terms/license/index.html) that Oracle requires prior to downloading.  This defaults to false because I can't accept the license for you, and needs to be set to true in order for any of the Java-related roles to successfully run.

### python-dev

The `full_anaconda` boolean variable controls whether the full Anaconda Python distribution is installed rather than just the minimal distribution.  This option adds a substantial amount of time to the build process and uses several hundred megabytes of disk space.

### r-dev

The `cran_mirror` variable specifies which CRAN mirror to use.  The contents should be a URL from the [CRAN mirror list](http://cran.r-project.org/mirrors.html) without any further path information added on.

### ruby-dev

As is normal for Debian/Ubuntu Ruby packages, ruby1.9.1 actually installs the newest release in the 1.9 series that is API-compatible with 1.9.1, which is currently 1.9.3.

### virtualbox

If you'd like to install the Oracle VM VirtualBox Extension Pack to add RDP and several other features to VirtualBox, you'll have to specify the URL to the .vbox-extpack file in the `virtualbox_extpack_url` variable.  I don't do this by default because it's distributed under a [restrictive license](https://www.virtualbox.org/wiki/VirtualBox_PUEL).

## Future Plans

* Complete reworking of the 'python-dev' role.
* Figure out some reasonable Python/Ruby packages to preinstall.
* Roles to stand up IPython and IJulia instances.
* Split PHP into its own role.
* Add options for nightly/beta/snapshot versions as appropriate.
* Add options to change ports for servers.
* Add build-from-source fallbacks when practical.
* Add MySQL/MariaDB.
* Maybe add Neo4j
* Investigate writing custom modules to manage packages for cabal, opam, racket, julia, R.
