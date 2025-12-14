#include "kernel/types.h"
#include "user/user.h"

int main(void) {
    int t = uptime();
    printf("Ticks since boot: %d\n", t);
    exit(0);
}
