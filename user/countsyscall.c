#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int c = countsyscall();
    printf("Total system calls since boot: %d\n", c);

    exit(0);
}
