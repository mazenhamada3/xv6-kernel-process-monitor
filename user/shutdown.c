#include "kernel/types.h"
#include "user/user.h"

int main() {
    printf("Calling shutdown...\n");
    shutdown();
    return 0;
}
