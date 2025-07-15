SRC		=	z.c
OBJ		=	$(SRC:%.c=%.o)
NAME	=	libex.a

default_target = all
$(NAME)	:	$(OBJ)
	$(AR) $(ARFLAGS) $@ $?

all:	$(NAME)
clean	:; $(RM) $(OBJ)
fclean	:	clean; $(RM) $(NAME)
re		:
	$(MAKE) fclean
	$(MAKE) all
(%):% # turn off implicit rule that updates archives per updated object, instead let it be done all at once
