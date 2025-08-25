#!/usr/bin/env bash

#
# For those reading through the script, good on you for not trusting some random
# script you found on the internet.
# The script should be fairly easy to understand, and i've tried to comment
# where things can become a bit unclear if you've not read that many bash
# scripts.
# The generated makefiles themselves are almost entirely uncommented, and i aim
# to make them a bit more educational in a bit. for now i think its fine, as i'd
# rather first make it fully capable of creating a makefile for most of the
# projects in the core curriculum
#
# - the goblin in Codam's walls


#
# PLANNED
#
# archive support => create specific functionality for if the target binary is
# an archive and not an executable => UPDATE Should now work as intended
#
# Library extensions => create specific functionality for a subset of commonly
# used 42 school libraries, such as minilibx and MLX42
#
# themes => different themes for different command names, i.e: should you name
# the makemake script "khan maykr" it will spit doom related tidbits at you
# instead of the standard dune related tidbits
# dune and doom are currently the only ones i can think of funny things for :P
#
# There is currently no plan for supporting projects with multiple target
# binaries (e.g. minitalk).
# There is currently no plan for supporting splitting projects based on
# mandatory and bonus parts.
# Both previous scenarios are trivial to create makefiles for however, just make
# them yourself.

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
	local targetbin language flags bindir depdir has_libs libdir change standard c_standard cpp_standard default_rule arflags
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

	. "${variables}" || fatal "failed to source variables" # get various variables that have to do with theming mostly
	. "${functions}" || fatal "failed to source functions" # get our functions. most of them are defined in a separate file such that the definitions are not made available to the shell calling makemake

	echo -n "${prelude}"

	change="false"
	if [ -e ${savefile} ]; then change="true" . "${savefile}"; fi
	if [ -z ${targetbin} ]; then change="true" get_targetbin && echo ""; fi
	if [ -z ${language} ]; then change="true" get_language && echo ""; fi
	if [ -z ${bindir} ]; then change="true" get_bindir && echo ""; fi
	if [ -z ${depdir} ]; then change="true" get_depdir && echo ""; fi
	if [[ -z ${has_libs} || ( ${has_libs} = "true" && -z ${libdir} ) ]]; then change="true" get_libdir && echo ""; fi
	if [ -z ${srcdirs} ]; then change="true" get_srcdirs && echo ""; fi
	if [ -z ${incdirs} ]; then change="true" get_incdirs && echo ""; fi
	if [ ${change} = "true" ]; then update_savefile; fi

	update_srcfiles
	if [ ! -e "${makefile}" -o ${change} = "true" ]; then update_makefile; fi
}
main "$(realpath `which $0`)" $@
