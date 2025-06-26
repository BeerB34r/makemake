#!/bin/env bash

echo "Bless the Maker and His water.
Bless the coming and going of Him.
May His passage cleanse the world.
May He keep the world for His people.

"

savefile="sand.trout"

# check if this is the initial run of makemake
if [ -e ${savefile} ]; then
	. ${savefile}
else
	echo "will this project be using C or CPP?"
	select lang in c cpp
	do
		case ${lang} in 
			"c")
				language=c
				echo "language=c" >> ${savefile}
				echo "C chosen"
				break
				;;
			"cpp")
				language=cpp
				echo "language=cpp" >> ${savefile}
				echo "CPP chosen"
				break
				;;
		esac
	done
	echo "what directory should intermediary binary files be stored? (default: \"./bin/\")"
	read bindir
	bindir=${bindir:=./bin/}
	echo "bindir=${bindir}" >> ${savefile}
	echo "intermediary binaries stored in: ${bindir}"
	echo "will this project be using local libraries, such as minilibx? (y/n)"
	read reply
	if [ "${reply}" = "y" -o -z ${reply} ]; then
		echo "in what directory are the libraries stored? (default: \"./lib/\")"
		read libdir
		libdir=${libdir:=./lib/}
		echo "libdir=${libdir}" >> ${savefile}
		echo "libraries stored in: ${libdir}"
		echo "NOTE: this makefile generator assumes that each library has its own directory, and outputs an archive file corresponding to its directory name, i.e: ./lib/libfoo => ./lib/libfoo/libfoo.a"
		echo "if this is not the case for your project, you must manually change this yourself"
	fi
fi

# ask for user input on everything not provided by any previous runthrough of
# makemake
if [ -z ${directories} ]; then
	directories=(`find . -type d -not -path '*/.*'` "quit")
fi
get_srcdirs() {
	if [ -z ${bindir} ]; then bindir="./bin/"; fi
	if [ -z ${srcdirs} ]; then
		echo "which of the following directories contain your source files? if soure files are nested, please submit multiple directories"
		select option in "${directories[@]}"
		do
			case ${option} in
				"quit")
					echo "you have selected ${srcdirs[@]}"
					echo "is this correct? (y/n)"
					read reply
					if [ "${reply}" = "y" -o -z ${reply} ]; then
						break
					fi
					echo "selection canceled"
					exit 1
					;;
				*)
					srcdirs=(${srcdirs[@]} ${option})
					;;
			esac
		done
		echo "srcdirs=(`echo ${srcdirs[@]} | sed -E 's/$/"/; s/^/"/; s/ /" "/'`)" >> ${savefile}
	fi
}
get_incdirs() {
	if [ -z ${incdirs} ]; then
		echo "which of the following directories contain your header files? if soure files are nested, please submit multiple directories"
		select option in "${directories[@]}"
		do
			case ${option} in
				"quit")
					echo "you have selected ${incdirs[@]}"
					echo "is this correct? (y/n)"
					read reply
					if [ "${reply}" = "y" -o -z ${reply} ]; then
						break
					fi
					echo "selection canceled"
					exit 1
					;;
				*)
					incdirs=(${incdirs[@]} ${option})
					;;
			esac
		done
		echo "incdirs=(`echo ${incdirs[@]} | sed -E 's/$/"/; s/^/"/; s/ /" "/'`)" >> ${savefile}
	fi
}
get_srcdirs
echo "source directories: ${srcdirs[@]}"
get_incdirs
echo "include directories: ${incdirs[@]}"
