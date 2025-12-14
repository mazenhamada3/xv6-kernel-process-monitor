#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (argv[1][0] == '-') {
    printf("You Can`t Put Negative Value\n");
    exit(1);
}

  if(strcmp(argv[1],"?")==0){
    printf("Usage: fact number\n");
    exit(1);
  }
  int x=atoi(argv[1]);
  int sum=1;
if (argc!=2){
  printf("error you cant put more than one number\n");
  exit(1);
}
else if(x>12){
  printf("Can`t Handel Large Value (Due to Overflow)\n");
  exit(1);
}
else{
 for(int i=1;i<x+1;i++)
 {
  sum=sum*i;
 }
  printf("Factorial = %d\n", sum);

}
  exit(0);
}
