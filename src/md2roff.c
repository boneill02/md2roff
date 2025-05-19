#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    char *md2ms = "md2roff -ms";
    char *md2man = "md2roff -man";

    if (!strcmp(argv[1], "-ms")) {
        argv[1] = md2ms;
        execvp("md2ms", &argv[1]);
    } else if (!strcmp(argv[1], "-man")) {
        argv[1] = md2man;
        execvp("md2man", &argv[1]);
    }

    printf("Usage: %s [-ms|-man] [args]\n", argv[0]);
    return 0;
}