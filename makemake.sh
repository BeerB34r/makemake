#!/usr/bin/env bash

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
# sit through the questionnaire every time => currently working (to a certain
# extent)
#
# themes => different themes for different command names, i.e: should you name
# the makemake script "khan maykr" it will spit doom related tidbits at you
# instead of the standard dune related tidbits
# dune and doom are currently the only ones i can think of funny things for :P

fatal(){
	echo "[FATAL] $@"
	exit 1
}

main() {
	# declare functions to be local so they do not bleed into the outer scope
	local -f _swhich ensure_directories
	local -f default_targetbin default_bindir default_depdir default_libdir
	local -f get_targetbin get_language get_bindir get_depdir get_libdir get_srcdirs get_incdirs
	local -f update_savefile update_srcfiles update_makefile
	# naming/theming
	local makemake_theme makefile prelude savefile maker_header
	# non-cosmetic variables always used by makemake
	local targetbin language flags bindir depdir has_libs libdir change standard c_standard cpp_standard
	local -a directories srcdirs srcfiles incdirs
	# find utils
	local makemake variables functions themes
	makemake="$1"
	variables="${makemake%/*}/utils/variables"
	functions="${makemake%/*}/utils/functions"
	themes="${makemake%/*}/themes/"

	if [ -e ${HOME}/.makemakerc ]; then
		. ${HOME}/.makemakerc
	fi

	. "${variables}" || fatal "failed to source variables"
	. "${functions}" || fatal "failed to source functions"

	echo -n "${prelude}"

	change="false"
	if [ -e ${savefile} ]; then change="true" . "${savefile}"; fi
	if [ -z ${targetbin} ]; then change="true" get_targetbin && echo ""; fi
	if [ -z ${language} ]; then change="true" get_language && echo ""; fi
	if [ -z ${bindir} ]; then change="true" get_bindir && echo ""; fi
	if [ -z ${depdir} ]; then change="true" get_depdir && echo ""; fi
	if [[ -z ${has_libs} || ( ${has_libs} = "true" && -z ${libdir} ) ]]; then change="true" get_libdir && echo ""; fi
	if [ ${change} = "true" ]; then update_savefile; fi

	# ask for user input on everything not provided by previous runs
	if [ -z ${srcdirs} ]; then change="true" get_srcdirs && echo ""; fi
	if [ -z ${incdirs} ]; then change="true" get_incdirs && echo ""; fi
	if [ ${change} = "true" ]; then update_savefile; fi

	update_srcfiles
	if [ ! -e "${makefile}" -o ${change} = "true" ]; then update_makefile; fi
}
main "$(realpath `which $0`)" $@
