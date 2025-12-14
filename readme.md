# xv6 Kernel Process Monitor & Custom Scheduler

**A modified UNIX-like kernel focusing on System Visibility, Process Enumeration, and Resource Control.**

![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Language](https://img.shields.io/badge/language-C-orange.svg) ![Platform](https://img.shields.io/badge/platform-RISC--V-red.svg)

## 🛡️ Project Overview (Security & Systems Focus)

This project involves deep kernel modifications to the **xv6-riscv** operating system. While traditional OS projects focus solely on performance, this implementation prioritizes **System Visibility** and **Control**—core concepts in **Security Operations (SOC)** and **Malware Analysis**.

The kernel was enhanced with:
1.  **Process Introspection (EDR-like Visibility):** Custom system calls to enumerate active processes, inspect their states (`RUNNING`, `SLEEPING`), and track their lifecycle.
2.  **Resource Governance:** Implementation of three distinct CPU scheduling algorithms to control how processes consume resources.
3.  **Kernel-User Bridging:** New interfaces allowing user-space tools to modify kernel-level process priorities dynamically.

---

## 📥 Installation & Setup

Follow these exact steps to download and run the kernel.

### 1. Clone the Repository
Open your terminal and run the following commands to download the project and enter the directory:

```bash
git clone [https://github.com/mazenhamada3/xv6-kernel-process-monitor.git](https://github.com/mazenhamada3/xv6-kernel-process-monitor.git)
```
### Navigate into the project directory
```bash
cd xv6-kernel-process-monitor
```
#### 2. Compile and Boot (QEMU)
To visualize the scheduling flow clearly without multi-core noise, it is strictly recommended to run the kernel with 1 CPU.
```bash
make CPUS=1 qemu
```
To exit QEMU: Press `Ctrl+A`, release, then press `X`)
## 💻 Command Reference & Usage
have implemented custom user-space programs to interact with the kernel features. Once the OS is booted (you see the `$` prompt), use these commands.
### 1. `metrics` (System Monitor)
Description: The primary visibility tool. It acts like a simplified Task Manager or ps command, allowing analysts to inspect live process states.
Usage:
```bash
metrics
```
utput Explanation:

Global Stats: Average turnaround/waiting times for finished processes.

Active Process Table: A live list showing:

`PID`: Process ID (Target for analysis).

`Prio`: Current Priority Level.

`State`: What the process is doing (Running vs. Waiting).

`WaitT`: Accumulative time spent waiting (Starvation detection).
### 2. `chsched` (Change Scheduler)
Description: Hot-swaps the kernel's scheduling algorithm on the fly without rebooting.
Usage:
```bash
chsched <policy_id>
```
Arguments:

`0`: Round Robin (Default)

`1`: FCFS (First-Come, First-Served)

`2`: Priority (Strict Priority)

Example:

```bash
$ chsched 2
```
### 3. `chprio` (Change Priority)
Description: Modifies the execution priority of a live process. This is critical for testing the Priority Scheduler.
Usage:
```bash
chprio <pid> <new_priority>
```
Arguments:

`pid`: The target Process ID (find this using `metrics`).

`new_priority`: A number from `0` (Highest/Critical) to `20` (Lowest).

Example:

```bash
$ chprio 5 0
```
### 4. `spin` (Load Generator)
Description: A dummy program that performs heavy calculation loops to simulate a CPU-intensive application. Use this to stress-test the scheduler.
Usage:
```bash
spin <iterations>
```
Example:
```bash
$ spin 5000 &
```
##🛠️ Technical Implementation Details

This section outlines the low-level kernel modifications made to support the new features.
### 1. Kernel Structures (`kernel/proc.h`)

The `struct proc` was extended to track process-specific scheduling data:

`int priority`: Stores the dynamic priority level (Default: 10).

`uint creation_time`: Timestamp of process creation (ticks) for FCFS ordering.

`uint total_waiting_time`: Accumulator for time spent in the `RUNNABLE` state.

`uint last_runnable_time:` Timestamp marking when a process entered the ready queue.

`uint64 arrival_id`: A unique, monotonic sequence ID used as a tie-breaker for processes created simultaneously.

### 2. New System Calls (`kernel/sysproc.c`)

Three new system calls were registered in the syscall table:

`sys_setscheduler(int policy)`: Updates the global `sched_mode` variable and resets kernel metrics.

`sys_setpriority(int pid, int priority)`: Locates a process by PID and updates its priority field.

`sys_getmetrics(struct sched_metrics *m)`: Performs a copy-out operation to transfer internal kernel statistics (turnaround time, wait time) to user space.
### 3. Scheduler Algorithms (`kernel/proc.c`)

The default Round Robin loop was replaced with a switchable logic block:

Round Robin (RR):

Iterates through the process table cyclically.

Uses standard time-slicing (timer interrupts) to yield CPU.

First-Come-First-Served (FCFS):

Selection Logic: Scans the entire process table to find the process with the lowest `creation_time`.

Tie-Breaking: Uses `arrival_id` to enforce strict ordering for processes created in the same tick.

Preemption: Modified `yield()` to disable preemption, ensuring a process runs to completion or blocks on I/O.

Priority Scheduling:

Selection Logic: Selects the `RUNNABLE` process with the lowest `priority` value (0 is highest importance).

Tie-Breaking: If priorities are equal, falls back to FCFS logic (oldest process wins).

Preemption: Fully preemptive; a higher-priority process becoming ready will immediately interrupt a lower-priority one.
