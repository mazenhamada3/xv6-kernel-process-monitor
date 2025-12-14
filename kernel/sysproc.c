#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

extern int setpriority(int pid, int priority);
extern int setscheduler(int policy);
extern void populate_metrics(uint64 *turnaround, uint64 *waiting, uint64 *finished);

extern struct proc proc[NPROC];
uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}


int
sys_getppid(void)
{
    struct proc *p = myproc();
    if(p->parent)
        return p->parent->pid;
    return 0;
}

uint64
sys_getptable(void)
{
    uint64 user_buf;   // pointer passed by user
    int n;

    // get arguments: (int nproc, struct procinfo *buf)
    argint(0, &n);
    argaddr(1, &user_buf);

    if (n < 1 || user_buf == 0)
        return 0;

    struct procinfo info;
    struct proc *p;
    struct proc *mp = myproc();

    int count = 0;

    for (p = proc; p < &proc[NPROC] && count < n; p++) {
        acquire(&p->lock);
        if (p->state != UNUSED) {
            info.pid = p->pid;
            info.ppid = p->parent ? p->parent->pid : 0;
            info.state = p->state;
            info.sz = p->sz;
            safestrcpy(info.name, p->name, sizeof(info.name));

            if (copyout(mp->pagetable,
                        user_buf + count * sizeof(info),
                        (char *)&info,
                        sizeof(info)) < 0) {
                release(&p->lock);
                return 0;
            }

            count++;
        }
        release(&p->lock);
    }

    return count; // number of processes copied
}

//p3
uint64
sys_setpriority(void)
{
  int pid, priority;
  argint(0, &pid);       // Direct call, no "if" check
  argint(1, &priority);
  return setpriority(pid, priority);
}

uint64
sys_setscheduler(void)
{
  int policy;
  argint(0, &policy);    // Direct call, no "if" check
  return setscheduler(policy);
}

uint64
sys_getmetrics(void)
{
  uint64 addr;
  argaddr(0, &addr);

  // 1. Calculate Global Averages
  uint64 t, w, f;
  populate_metrics(&t, &w, &f);

  struct sched_metrics {
    uint64 turnaround;
    uint64 waiting;
    uint64 finished;
  } m;

  m.turnaround = t;
  m.waiting = w;
  m.finished = f;

  if(copyout(myproc()->pagetable, addr, (char *)&m, sizeof(m)) < 0)
    return -1;

  // 2. PRINT ACTIVE PROCESSES (The "Lazy" Way)
  // We print directly from the kernel to the console.
  struct proc *p;
  printf("\n--- Active Process List (Kernel Print) ---\n");
  printf("PID\tPrio\tState\tWaitT\tCreated\n");

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->state != UNUSED){
       // Calculate current age (turnaround so far)
       // int age = ticks - p->creation_time;

       const char *state_name = "???";
       if(p->state == SLEEPING) state_name = "SLEEP";
       else if(p->state == RUNNABLE) state_name = "RUNBL";
       else if(p->state == RUNNING) state_name = "RUN";

       printf("%d\t%d\t%s\t%d\t%d\n",
              p->pid, p->priority, state_name, p->total_waiting_time, p->creation_time);
    }
    release(&p->lock);
  }
  printf("------------------------------------------\n");

  return 0;
}
