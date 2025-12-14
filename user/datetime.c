#include "kernel/types.h"
#include "user/user.h"

int main()
{
    struct datetime dt;

    if (datetime(&dt) < 0) {
        printf("Failed to get datetime\n");
        exit(1);
    }

    printf("Current Date and Time: %d-%d-%d %d:%d:%d\n",
           dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);

    exit(0);
}
