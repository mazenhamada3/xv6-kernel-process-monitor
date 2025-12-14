#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define MAX_LINE 256

void print_usage() {
    printf("Usage: diff file1 file2\n");
    printf("Compare two files line by line.\n");
    printf("Example: diff a.txt b.txt\n");
    printf("         diff ? (for help)\n");
}

// Read one line from file descriptor
// Returns: 1 if line read, 0 if EOF
int read_line(int fd, char *buffer, int max_size) {
    int i = 0;
    char ch;

    while (i < max_size - 1) {
        int n = read(fd, &ch, 1);
        if (n <= 0) {
            // EOF or error
            break;
        }

        if (ch == '\n') {
            break;
        }

        buffer[i++] = ch;
    }

    buffer[i] = '\0';  // Null-terminate

    // Return 1 if we read something OR if we stopped at newline
    return (i > 0 || (i == 0 && ch == '\n'));
}

int main(int argc, char *argv[]) {
    // Help feature
    if (argc == 2 && strcmp(argv[1], "?") == 0) {
        print_usage();
        exit(0);
    }

    if (argc != 3) {
        printf("Usage: diff file1 file2\n");
        printf("Try 'diff ?' for more information.\n");
        exit(1);
    }

    // Open files
    int fd1 = open(argv[1], O_RDONLY);
    if (fd1 < 0) {
        printf("diff: cannot open '%s'\n", argv[1]);
        exit(1);
    }

    int fd2 = open(argv[2], O_RDONLY);
    if (fd2 < 0) {
        printf("diff: cannot open '%s'\n", argv[2]);
        close(fd1);
        exit(1);
    }

    char line1[MAX_LINE], line2[MAX_LINE];
    int line_num = 1;
    int differences = 0;
    int eof1 = 0, eof2 = 0;

    while (1) {
        // Read one line from each file
        int has_line1 = read_line(fd1, line1, MAX_LINE);
        int has_line2 = read_line(fd2, line2, MAX_LINE);

        // Check for EOF
        if (!has_line1) eof1 = 1;
        if (!has_line2) eof2 = 1;

        // Both files at EOF
        if (eof1 && eof2) {
            break;
        }

        // Compare the lines
        if (has_line1 && has_line2) {
            // Both files have this line
            if (strcmp(line1, line2) != 0) {
                if (differences > 0) printf("\n");
                printf("Line %d differs:\n", line_num);
                printf("< %s\n", line1);
                printf("> %s\n", line2);
                differences++;
            }
        } else if (has_line1 && !has_line2) {
            // Only first file has this line
            if (differences > 0) printf("\n");
            printf("Line %d only in %s:\n", line_num, argv[1]);
            printf("< %s\n", line1);
            differences++;
        } else if (!has_line1 && has_line2) {
            // Only second file has this line
            if (differences > 0) printf("\n");
            printf("Line %d only in %s:\n", line_num, argv[2]);
            printf("> %s\n", line2);
            differences++;
        }

        line_num++;
    }

    close(fd1);
    close(fd2);

    if (differences == 0) {
        printf("Files are identical\n");
    }

    exit(0);
}
