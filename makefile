SRC				=	x.c# generated automatically through posix find
SRCDIR			=	src/# chosen by user during creation

BIN				=	$(addprefix $(BINDIR),$(SRC:%.c=%.o))	# extension is chosen during makefile creation
BINDIR			=	bin/# (name) chosen by user during creation

LIBDIR			=	lib/# (name) chosen by user during creation
LIBRARIES		=	libex/libex.a# basename without directory is added by user
LIB				=	$(addprefix $(LIBDIR),$(LIBRARIES))

INCDIR			=	inc# chosen (and potentially expanded) by the user during creation
INC				=	$(addprefix -I,$(INCDIR) .)

DEPFLAGS		=	-M -MMD -MT $(BINDIR)#always the same
DEPDIR			=	dep/

CC				=	cc
CFLAGS			=	-Wall -Wextra -Werror $(INC)
#----------------	Only one of the two is actually put into the program itself, depending on what the language of the project is
CXX				=	c++
CXXFLAGS		=	-Wall -Wextra -Werror $(INC)# and potentially --std=c++98 should the users campus require it

NAME			=	foo# chosen by user during makefile creation
VPATH			=	$(SRCDIR)
.DEFAULT_GOAL	=	$(NAME)
.PHONY			:	all clean fclean re
.PRECIOUS		:	$(BINDIR)

include			$(addprefix $(BINDIR), $(SRC:%.c=%.d))

define libscmd
for dir in $(dir $(LIB)); do \
	$(MAKE) -C $$dir $(1); done ;
endef

$(LIB)	:
	+$(MAKE) -C $(dir $@)

# default commands
all				:	$(NAME)
clean			:
	$(RM) -r $(BINDIR)
	+$(call libscmd, clean)
fclean			:
	$(RM) -r $(BINDIR)
	$(RM) $(NAME)
	+$(call libscmd, fclean)
re				:
	+$(MAKE) fclean
	+$(MAKE)

%/				:
	mkdir -p $@

$(DEPDIR)%.d				:	%.c | $(DEPDIR)#stolen directly from our beloved GNU make manual
	$(CC) $(DEPFLAGS)$(addsuffix .o,$(notdir $(basename $<))) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
$(BINDIR)%.o				: $(DEPDIR)%.d | $(BINDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

# extra commands
run				:	$(NAME);	./$(NAME)
debug			:	CFLAGS+=-g3
debug			:	CXXFLAGS+=-g3
debug			:	re

# bread and butter
$(NAME)			:	$(BIN) $(LIB)
	$(CC) $(CFLAGS) $(INC) -o $@ $^
