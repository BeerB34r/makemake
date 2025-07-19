# makemake
a simple tool to create a not-so simple makefile

## Usage

when it is on the ${PATH}, simply call `makemake` at the projects root, and
follow the provided instructions.

## Installation instructions

Download the script itself, as well as its dependencies from the utils and
themes directories.

to skip the hassle, there's a script that will do all of that for you. read it
first.
```sh
curl 'https://raw.githubusercontent.com/BeerB34r/makemake/refs/heads/main/install.sh' | bash
```
this command installs the script into `./makemake`, creates a symlink to it in
${HOME}/bin, and prepends ${HOME}/bin to ${PATH} in the current shell, .bashrc
and .zshrc

## Customisation

You can customise a lot of the initial setup for a new project using a
.makemakerc file in your home directory. the example provided in this repository
lists and explains all the options intended to be used, and their default values
