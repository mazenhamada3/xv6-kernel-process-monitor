#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int i;
  int j;
  int x = 0;

  if(argc != 2){
    fprintf(2, "Usage: spin <iterations>\n");
    exit(1);
  }

  int t = atoi(argv[1]);
  int pid = getpid();

  printf("(%d) spin started\n", pid);

  // Outer loop: 't' times
  for(i = 0; i < t; i++){
    // Inner loop: 1 million times
    for(j = 0; j < 1000000; j++){
       x += j;
    }
  }

  // IMPORTANT: We print 'x' here.
  // This forces the compiler to actually run the loop above!
  printf("(%d) spin finished val=%d\n", pid, x);
  exit(0);
}
