#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(2, "Usage: sleep ticks\n");
        exit(1);
    }

    if (argv[1][0] == '?') {
        printf("Usage: sleep ticks\n");
        printf("Pause execution for specified number of ticks\n");
        exit(0);
    }

    int ticks = atoi(argv[1]);
    if (ticks < 0) {
        fprintf(2, "sleep: ticks must be non-negative\n");
        exit(1);
    }

    sleep(ticks);
    exit(0);
}
