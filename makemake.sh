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

echo "Bless the Maker and His water.
Bless the coming and going of Him.
May His passage cleanse the world.
May He keep the world for His people.
"
maker_header="#--------------------------------------------------------------------------------#
#                                                                                #
#                .                                                               #
#              *###. +..                                                         #
#             .###%####*.-*...                                                   #
#             -##%%%%*%#*%#  :                                                   #
#             +#%%%=.*%%%%+%%....                                                #
#            .#%%%%%#**%*%=%%%%....                                              #
#            .###%%-%+*:%%%%%%%@  .*     .                                       #
#            .%%%%%%%*@%#...*: #.  .=. #      -                                  #
#       .    .#=%%%%%*%%@%*. =.     ..= @  +                                     #
#      .*%#.. +%%@%@@@#@@.=:# .  :  * .@                                         #
#       ..@#:.#%%%@@@@%@@:-:*.-.. ..  . :.                                       #
#           #%*%%%=%%* +%%@+....# % - *  +        .                              #
#            .#%#%:=%%=#*..+#: ....... :. ..                                     #
#            =..%%%##*%.::..+*...  ..   .  .                                     #
#               ..%%-@*-.:%@:.. .#.=.  . .. ..                                   #
#                 . @@@=%%@:+.-*--:.:.+....+  :                                  #
#       .        ... @%-%:#.%@..+..* %..=  ... .*@=:.                            #
#                #  ....#@@%#*:.**.@@**..%--.  ..@...               .#....       #
#              ....  . ...@@@.%.+%*=-#.:::+.  . .  %  +*..                       #
#                    .   ...@@-%@-.#-.@..#:.... .   *..             :            #
#                   =      ..#@#@@+:--@-@.::.%.  ...@ .. -                       #
#                  ..      .  .%@@@@=%@@ #:.--+. -   .    .@.-=.        ..      .#
#      ..       .    ...-+*#==--@@@@@:. @@:-%..#=.:.-..  .   :.        . :*%.    #
#                                ..%@@@@.@:%#=+*@%..    .**.-. @. * ..... =.*..  #
#                             .    . @@+.@.#@:+--..=.::.: :.:..--+=... ..........#
#                      . .... ..... ..:@@@@*@..@....-*+:.+#@:@@ .... ....... ....#
#              ....   ::::*++-:.=:    .::+@@@@%@%*.#-. -.@@  .  ....           ..#
# **-....  .  .=#:+-..        .. ..  .... .#@@@%+=@-#@.                      ....#
#.-.     ........=:..     .+.-#+*##+##++#%%%#@@@=-                               #
#  .    .... . . . ..   . . .*-...#+==:=..:@#.                                  .#
#   .#+.  . .++.     .:+:==:.. .:*##+=-@=..                                      #
#       . .-=:..:-. ....  ....=*=--@%@.                                          #
#    .  .   ...-%+=+%.#%%=::.=......                                             #
#+-----:::..     ..........-@:@                                                  #
#..        .. . .   ..+...%.                                                     #
#:         ....+#-..                                                             #
#... ......                                                                      #
#..                                                                              #
#.                                                                               #
#                         Bless the Maker and His water.                         #
#                       Bless the coming and going of Him.                       #
#                       May His passage cleanse the world.                       #
#                     May He keep the world for His people.                      #
#--------------------------------------------------------------------------------#"

savefile="sand.trout"

# check if this is the initial run of makemake
if [ -e ${savefile} ]; then
	. ${savefile}
else
	echo "what is the name of the target binary? (default: \"`basename $(realpath .)`\")"
	read targetbin
	targetbin=${targetbin:=`basename $(realpath .)`}
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
what directory should intermediary binary files be stored? (default: \"bin/\")"
	read bindir
	bindir=${bindir:=bin/}
	echo "intermediary binaries stored in: ${bindir}"
	echo "
what directory should generated dependency files be stored (default: \"dep/\")"
	read depdir
	depdir=${depdir:=dep/}
	echo "dependency files stored in: ${depdir}"
	echo "
will this project be using local libraries, such as minilibx? (y/n)"
	read reply
	if [ "${reply}" = "y" -o -z ${reply} ]; then
		echo "in what directory are the libraries stored? (default: \"lib/\")"
		read libdir
		libdir=${libdir:=lib/}
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

PS3="Please select a number: "
# ask for user input on everything not provided by any previous runthrough of
# makemake
if [ -z ${directories} ]; then
	directories=(`find . -type d -not -path '*/.*' -printf "%P/\n"` "quit")
fi
get_srcdirs() {
	if [ -z ${bindir} ]; then bindir="bin/"; fi
	if [ -z ${srcdirs} ]; then
		echo "
which of the following directories contain your source files? if source files are in nested directories, please submit all relevant directories"
		select option in "${directories[@]:1}"
		do
			if [ -z ${REPLY} -o ${REPLY} = "q" -o ${REPLY} = "quit" ]; then option="quit"; fi;
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
					echo "appended ${option} to source directories"
					srcdirs=(${srcdirs[@]} ${option})
					;;
			esac
		done
		echo "srcdirs=(`echo ${srcdirs[@]} | sed -E 's/$/"/; s/^/"/; s/ /" "/'`)" >> ${savefile}
	fi
}
get_incdirs() {
	if [ -z ${incdirs} ]; then
		echo "
which of the following directories contain your header files? if header files are in nested directories, please submit all relevant directories"
		select option in "${directories[@]:1}"
		do
			if [ -z ${REPLY} -o ${REPLY} = "q" -o ${REPLY} = "quit" ]; then option="quit"; fi;
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
					echo "appended ${option} to header directories"
					incdirs=(${incdirs[@]} ${option})
					;;
			esac
		done
		echo "incdirs=(`echo ${incdirs[@]} | sed -E 's/$/"/; s/^/"/; s/ /" "/'`)" >> ${savefile}
	fi
}
update_makefile() {
	if [ -e 'makefile' ]; then
		mv makefile makefile.bk
	fi
	echo "${maker_header}

SRC = ${srcfiles}
SRCDIR = ${srcdirs[@]}"'

BIN = $(addprefix $(BINDIR),$(SRC:%.c=%.o))'"
BINDIR = ${bindir}
" > makefile
	if [ ! -z ${libdir} ]; then 
		echo "LIBDIR = ${libdir}
LIBRARIES = `find ${libdir} -mindepth 1 -type d -printf "%P/%P.a "`"'
LIB = $(addprefix $(LIBDIR),$(LIBRARIES))
' >> makefile
	fi
	echo "INCDIR = ${incdirs[@]}"'
INC = $(addprefix -I,$(INCDIR) .)'"

DEPDIR = ${depdir}"'
DEPFLAGS = -MM -MF $@ -MT $@ -MT $(BINDIR)$(addsuffix .o,$(notdir $(basename $<)))
' >> makefile
	if [ ${language} = "c" ]; then
		echo "CC = cc
CFLAGS = ${flags}"' $(INC)
' >> makefile
	else
		echo "CXX = c++
CXXFLAGS = ${flags}"' $(INC)
' >> makefile
	fi
	echo "NAME = ${targetbin}"'
VPATH = $(SRCDIR)
.DEFAULT_GOAL = $(NAME)
.PHONY : all clean fclean re
.PRECIOUS : $(BINDIR) $(DEPDIR)

include $(addprefix $(DEPDIR), $(SRC:%.c=%.d))

define libscmd
for dir in $(dir $(LIB)); do \
	$(MAKE) -C $$dir $(1); done ;
endef

$(LIB) :
	+$(MAKE) -C $(dir $@)

# Default commands
all : $(NAME)
clean :
	$(RM) -r $(BINDIR)
	+$(call libscmd, clean)
fclean :
	$(RM) -r $(BINDIR) $(DEPDIR)
	$(RM) $(NAME)
	+$(call libscmd, fclean)
re :
	+$(MAKE) fclean
	+$(MAKE)

%/ :
	mkdir -p $@

$(DEPDIR)%.d : %.'"${language}"' | $(DEPDIR)
	$('`if [ ${language} = "c" ];then echo "CC"; else echo "CXX"; fi`') $('`if [ ${language} = "c" ];then echo "CFLAGS"; else echo "CXXFLAGS"; fi`') $(CPPFLAGS) $(DEPFLAGS) $<

$(BINDIR)%.o : %.'"${language}"' | $(BINDIR)
	$('`if [ ${language} = "c" ];then echo "CC"; else echo "CXX"; fi`') $('`if [ ${language} = "c" ];then echo "CFLAGS"; else echo "CXXFLAGS"; fi`') $(CPPFLAGS) -c -o $@ $<

# Extra commands
run : $(NAME); ./$(NAME)
debug : CFLAGS+=-g3
debug : CFLAGS+=-g3
debug : re

# bread and butter
$(NAME) : $(BIN) $(LIB)' >> makefile
	if [ ${language} = "c" ]; then
		echo '	$(CC) $(CFLAGS) $(INC) -o $@ $^' >> makefile
	else
		echo '	$(CXX) $(CXXFLAGS) $(INC) -o $@ $^' >> makefile
	fi
}

get_srcdirs
get_incdirs
new_srcfiles=`find ${srcdirs[*]} -maxdepth 1 -type f -name "*.${language}" -printf "%f " | sed -E 's/ $//g'`
if [ ! "${new_srcfiles}" = "${srcfiles}" ]; then
	sed -i'' '/srcfiles.*/d' ${savefile}
	echo "srcfiles=\"${new_srcfiles}\"" >> ${savefile}
	echo "srcfiles changed to: ${new_srcfiles}"
	srcfiles="${new_srcfiles}"
	update_makefile
else
	echo "no change to srcfiles"
fi
