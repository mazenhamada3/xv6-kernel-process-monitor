#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(2, "Usage: chsched <0:RR, 1:FCFS, 2:PRIO>\n");
    exit(1);
  }

  int policy = atoi(argv[1]);
  if (setscheduler(policy) < 0) {
    fprintf(2, "Error: Invalid policy.\n");
    exit(1);
  }

  if (policy == 0) printf("Scheduler: Round Robin\n");
  else if (policy == 1) printf("Scheduler: FCFS\n");
  else if (policy == 2) printf("Scheduler: Priority\n");

  exit(0);
}
