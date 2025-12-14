#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
  struct sched_metrics m;

  if (getmetrics(&m) < 0) {
    fprintf(2, "Error getting metrics.\n");
    exit(1);
  }

  printf("Scheduler Metrics:\n");
  printf("  Finished Processes: %lu\n", m.finished);

  if (m.finished > 0) {
      // We divide by 'finished' to get the average
      printf("  Avg Turnaround Time: %lu ticks\n", m.turnaround / m.finished);
      printf("  Avg Waiting Time: %lu ticks\n", m.waiting / m.finished);
  } else {
      printf("  No processes finished yet.\n");
  }

  exit(0);
}
