#!/bin/env bash

#
# For those reading through the script, good on you for not trusting some random
# script you found on the internet. I would like to formally apologize for the
# state you will find this script in, as it is currently quite unpolished. i
# will hopefully remedy this eventually, but until that moment comes you will
# just have to deal with it.
# eventually i'd like for this script, if read in its entirety, to teach you how
# and why certain decisions were made for this scripts generated makefiles.
# until then, i urge you to examine and interrogate the script and makefile
# for as long as you have questions remaining.
#
# - the goblin in Codam's walls


#
# PLANNED
# .makerc => standardise the project creation process for those who dont want to
# sit through the questionnaire every time
#
# themes => different themes for different command names, i.e: should you name
# the makemake script "khan maykr" it will spit doom related tidbits at you
# instead of the standard dune related tidbits
# dune and doom are currently the only ones i can think of funny things for :P

if [ -e ${HOME}/.makemakerc ]; then
	. ${HOME}/.makemakerc
fi

. utils/variables
. utils/functions

echo -n "${prelude}"

# check if this is the initial run of makemake
if [ -e ${savefile} ]; then
	. ${savefile}
else
	echo "what is the name of the target binary? (default: \"`default_targetbin`\")"
	read targetbin
	targetbin=${targetbin:=`default_targetbin`}
	echo "target binary shall be named ${targetbin}"
	echo "
will this project be using C or CPP?"
	select lang in c cpp
	do
		case ${lang} in 
			"c")
				language=c
				flags="-Wall -Wextra -Werror"
				echo "C chosen"
				break
				;;
			"cpp")
				language=cpp
				echo "CPP chosen"
				echo "are you required to (or wanting to) use the c++98 standard? (y/n)"
				read standard
				if [ ${standard} = "y" -o -z ${standard} ]; then
					echo "c++98 standard enforced on current project"
					flags="-Wall -Wextra -Werror --std=c++98"
				else
					flags="-Wall -Wextra -Werror"
				fi
				break
				;;
		esac
	done
	echo "
what directory should intermediary binary files be stored? (default: \"`default_bindir`\")"
	read bindir
	bindir=${bindir:=`default_bindir`}
	echo "intermediary binaries stored in: ${bindir}"
	echo "
what directory should generated dependency files be stored (default: \"`default_depdir`\")"
	read depdir
	depdir=${depdir:=`default_depdir`}
	echo "dependency files stored in: ${depdir}"
	echo "
will this project be using local libraries, such as minilibx? (y/n)"
	read reply
	if [ "${reply}" = "y" -o -z ${reply} ]; then
		echo "in what directory are the libraries stored? (default: \"`default_libdir`\")"
		read libdir
		libdir=${libdir:=`default_libdir`}
		echo "libraries stored in: ${libdir}"
		echo "NOTE: this makefile generator assumes that each library has its own directory, and outputs an archive file corresponding to its directory name, i.e: ./lib/libfoo => ./lib/libfoo/libfoo.a"
		echo "if this is not the case for your project, you must manually change this yourself"
	fi
	echo "targetbin=\"${targetbin}\"" > ${savefile}
	echo "language=${language}" >> ${savefile}
	echo "flags=\"${flags}\"" >> ${savefile}
	echo "bindir=\"${bindir}\"" >> ${savefile}
	echo "depdir=\"${depdir}\"" >> ${savefile}
	if [ ! -z ${libdir} ]; then
		echo "libdir=\"${libdir}\"" >> ${savefile}
	fi
fi

ensure_directories

# ask for user input on everything not provided by previous runs
if [ -z ${srcdirs} ]; then get_srcdirs; fi
if [ -z ${incdirs} ]; then get_incdirs; fi

update_srcfiles
update_makefile
