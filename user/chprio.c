#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(2, "Usage: chprio <pid> <priority>\n");
    exit(1);
  }

  int pid = atoi(argv[1]);
  int priority = atoi(argv[2]);

  if (setpriority(pid, priority) < 0) {
    fprintf(2, "Error: PID %d not found.\n", pid);
    exit(1);
  }

  printf("Priority of PID %d changed to %d\n", pid, priority);
  exit(0);
}
