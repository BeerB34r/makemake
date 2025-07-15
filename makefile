#--------------------------------------------------------------------------------#
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
#--------------------------------------------------------------------------------#

SRC = x.c
SRCDIR = src/

BIN = $(addprefix $(BINDIR),$(SRC:%.c=%.o))
BINDIR = bin/

LIBDIR = lib/
LIBRARIES = libex/libex.a 
LIB = $(addprefix $(LIBDIR),$(LIBRARIES))

INCDIR = inc/ lib/libex/
INC = $(addprefix -I,$(INCDIR) .)

DEPDIR = dep/
DEPFLAGS = -MM -MF $@ -MT $@ -MT $(BINDIR)$(addsuffix .o,$(notdir $(basename $<)))

CC = cc
CFLAGS = -Wall -Wextra -Werror $(INC)

NAME = shaihulud
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

$(DEPDIR)%.d : %.c | $(DEPDIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(DEPFLAGS) $<

$(BINDIR)%.o : %.c | $(BINDIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

# Extra commands
run : $(NAME); ./$(NAME)
debug : CFLAGS+=-g3
debug : CFLAGS+=-g3
debug : re

# bread and butter
$(NAME) : $(BIN) $(LIB)
	$(CC) $(CFLAGS) $(INC) -o $@ $^
