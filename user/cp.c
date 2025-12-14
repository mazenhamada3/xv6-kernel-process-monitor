#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define BSIZE 512

int main(int argc, char *argv[]) {
    int src_fd, dst_fd;
    char buf[BSIZE];
    int n;

    if (argc != 3) {
        fprintf(2, "Usage: cp source destination\n");
        exit(1);
    }

    if (argv[1][0] == '?') {
        printf("Usage: cp source destination\n");
        printf("Copy source file to destination\n");
        exit(0);
    }

    // Open source file
    if ((src_fd = open(argv[1], O_RDONLY)) < 0) {
        fprintf(2, "cp: cannot open %s\n", argv[1]);
        exit(1);
    }

    // Create destination file
    if ((dst_fd = open(argv[2], O_CREATE | O_WRONLY)) < 0) {
        fprintf(2, "cp: cannot create %s\n", argv[2]);
        close(src_fd);
        exit(1);
    }

    // Copy data
    while ((n = read(src_fd, buf, sizeof(buf))) > 0) {
        if (write(dst_fd, buf, n) != n) {
            fprintf(2, "cp: write error\n");
            close(src_fd);
            close(dst_fd);
            exit(1);
        }
    }

    if (n < 0) {
        fprintf(2, "cp: read error\n");
    }

    close(src_fd);
    close(dst_fd);
    exit(0);
}
