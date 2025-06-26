#include <unistd.h>

static int	strlen(char *s) {
	for (int i = 0;;i++) if (!s[i])
			return (i);
}
int	my_fancy_libary_puts(char *s) {
	return write(1, s, strlen(s));
}
