#include "kernel/types.h"
#include "user/user.h"

#define MAX_PROCS 64  // xv6 limit

int main() {
    // ---- Part 1: getpid + getppid ----
    int pid = getpid();
    int ppid = getppid();

    printf("Current Process:\n");
    printf("  PID:  %d\n", pid);
    printf("  PPID: %d\n\n", ppid);

    // ---- Part 2: getptable ----
    struct procinfo ptable[MAX_PROCS];

    int n = getptable(MAX_PROCS, ptable);  // <-- no cast!
    if (n <= 0) {
        printf("getptable failed.\n");
        exit(0);
    }

    printf("Process Table (%d processes):\n", n);
    printf("PID\tPPID\tSTATE\tSIZE\tNAME\n");
    printf("---------------------------------------------\n");

    for (int i = 0; i < n; i++) {
        printf("%d\t%d\t%d\t%lu\t%s\n",
               ptable[i].pid,
               ptable[i].ppid,
               ptable[i].state,
               ptable[i].sz,
               ptable[i].name);
    }

    exit(0);
}
