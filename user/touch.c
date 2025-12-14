#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(2, "Usage: touch filename\n");
        exit(1);
    }

    // Help flag
    if (argv[1][0] == '?') {
        printf("Usage: touch filename\n");
        printf("Create an empty file if it doesn't exist\n");
        exit(0);
    }

    // First check if file already exists
    int fd = open(argv[1], O_RDONLY);
    if (fd >= 0) {
        // File exists → print required message
        close(fd);
        printf("touch: file already exists\n");
        exit(1);
    }

    // File does NOT exist → create it
    fd = open(argv[1], O_CREATE | O_RDWR);
    if (fd < 0) {
        fprintf(2, "touch: cannot create %s\n", argv[1]);
        exit(1);
    }

    close(fd);
    exit(0);
}
