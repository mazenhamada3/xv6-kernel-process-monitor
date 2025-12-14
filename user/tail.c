#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define DEFAULT_LINES 10

int main(int argc, char *argv[])
{
    // Check for help/usage request
    if (argc > 1 && strcmp(argv[1], "?") == 0) {
        printf("Usage: tail [-n number] [filename]\n");
        printf("Display the last N lines of a file or standard input\n");
        exit(0);
    }

    int num_lines = DEFAULT_LINES;
    char *filename = 0;
    int fd;
    int i;

    // Simple argument parsing
    if (argc > 1 && strcmp(argv[1], "-n") == 0 && argc > 2) {
        num_lines = atoi(argv[2]);
        if (num_lines <= 0)
        num_lines = DEFAULT_LINES;
        if (argc > 3) filename = argv[3];
    } else if (argc > 1) {
        filename = argv[1];
    }

    // Open file
    if (filename) {
        if ((fd = open(filename, O_RDONLY)) < 0) {
            printf("tail: cannot open file\n");
            exit(1);
        }
    } else {
        fd = 0; // stdin
    }

    // Simple implementation - read and count lines
    int bytes_read;
    int line_count = 0;
    char *lines[100];
    int total_chars = 0;
    static char file_buffer[10000];

    // Read entire file
    while ((bytes_read = read(fd, file_buffer + total_chars, sizeof(file_buffer) - total_chars - 1)) > 0) {
        total_chars += bytes_read;
    }
    file_buffer[total_chars] = '\0';

    // Split into lines
    lines[0] = file_buffer;
    line_count = 1;

    for (i = 0; i < total_chars; i++) {
        if (file_buffer[i] == '\n' && line_count < 100) {
            file_buffer[i] = '\0';
            lines[line_count] = &file_buffer[i + 1];
            line_count++;
        }
    }

    // Show last N lines
    int start = (line_count > num_lines) ? (line_count - num_lines) : 0;
    for (i = start; i < line_count; i++) {
        printf(lines[i], strlen(lines[i]));
        printf("\n");
    }

    if (filename) close(fd);
    exit(0);
}
