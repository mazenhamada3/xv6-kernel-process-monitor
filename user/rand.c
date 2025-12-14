#include "kernel/types.h"
#include "user/user.h"

int main(void)
{
    printf("Random: %d\n", rand());
    exit(0);
}
