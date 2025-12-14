#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

#ifndef BOOT_EPOCH
#define BOOT_EPOCH 0
#endif

extern struct spinlock tickslock;
extern uint ticks;

extern int kbd_intr_count;
extern int total_syscalls;



uint64 sys_kbdint(void) { return kbd_intr_count; }
uint64 sys_countsyscall(void) { return total_syscalls; }

uint64 sys_uptime(void)
{
    acquire(&tickslock);
    uint xticks = ticks;
    release(&tickslock);
    return xticks;
}

// simple LCG random
static unsigned long seed = 1;
uint64 sys_rand(void)
{
    if (seed == 1)
        seed = ticks;
    seed = seed * 1103515245 + 12345;
    return (seed >> 16) & 0x7FFF;
}


uint64 sys_shutdown(void)
{
    printf("Shutting down xv6...\n");
    volatile uint32 *shutdown_reg = (uint32*)0x100000;
    *shutdown_reg = 0x5555;
    for (;;) ;
    return 0;
}

#define CAIRO_OFFSET (2 * 3600)

struct datetime {
    int year;
    int month;
    int day;
    int hour;
    int minute;
    int second;
    int weekday;
};

static int month_days[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

static int
is_leap_year(int year)
{
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

static void
unix_to_datetime(uint64 timestamp, struct datetime *dt)
{
    // Apply Cairo timezone offset
    timestamp += CAIRO_OFFSET;

    // Calculate weekday (Jan 1, 1970 was Thursday = 4)
    dt->weekday = (timestamp / 86400 + 4) % 7;

    // Calculate year
    uint64 days = timestamp / 86400;
    int year = 1970;

    while (1) {
        int days_in_year = is_leap_year(year) ? 366 : 365;
        if (days < days_in_year)
            break;
        days -= days_in_year;
        year++;
    }
    dt->year = year;

    // Calculate month
    int month;
    int days_in_month;
    for (month = 0; month < 12; month++) {
        days_in_month = month_days[month];
        if (month == 1 && is_leap_year(year))
            days_in_month = 29;

        if (days < days_in_month)
            break;
        days -= days_in_month;
    }
    dt->month = month + 1;
    dt->day = days + 1;

    // Calculate time of day
    uint64 secs_in_day = timestamp % 86400;
    dt->hour = secs_in_day / 3600;
    dt->minute = (secs_in_day % 3600) / 60;
    dt->second = secs_in_day % 60;
}

static uint64
get_current_time(void)
{
    // Read time CSR (standard RISC-V way to get time)
    // In QEMU virt, the clock frequency is typically 10MHz (10000000 ticks/sec)
    uint64 time_ticks = r_time();

    // Convert to seconds (ticks to seconds at 10MHz)
    uint64 seconds = time_ticks / 10000000;

    // Add to boot epoch (defined by Makefile at build time)
    return BOOT_EPOCH + seconds;
}

uint64
sys_datetime(void)
{
    struct datetime dt;
    struct proc *p = myproc();
    uint64 addr;

    argaddr(0, &addr);

    // Get current UNIX timestamp
    uint64 current_time = get_current_time();

    // Convert to datetime structure
    unix_to_datetime(current_time, &dt);

    // Copy to user space
    if(copyout(p->pagetable, addr, (char*)&dt, sizeof(dt)) < 0) {
        return -1;
    }

    return 0;
}
