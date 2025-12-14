#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

void print_usage() {
    printf("Usage: wc [OPTION]... [FILE]...\n");
    printf("Print newline, word, and character counts for each FILE.\n");
    printf("Options:\n");
    printf("  -l    print the line counts\n");
    printf("  -w    print the word counts\n");
    printf("  -c    print the character counts\n");
    printf("  -L    print the maximum line length\n");
    printf("With no FILE, read standard input.\n");
    printf("With no options, print -l, -w, -c.\n");
}

int main(int argc, char *argv[])
{
    // Default: show lines, words, chars (as per requirement)
    int show_lines = 0, show_words = 0, show_chars = 0, show_max_line = 0;
    int file_start = 1;
    int has_flags = 0;

    // Handle help
    if (argc > 1 && strcmp(argv[1], "?") == 0) {
        print_usage();
        exit(0);
    }

    // Parse flags
    if (argc > 1 && argv[1][0] == '-') {
        has_flags = 1;
        char *p = &argv[1][1];

        // Check for invalid flags
        while (*p) {
            if (*p != 'l' && *p != 'w' && *p != 'c' && *p != 'L') {
                printf("wc: invalid option -- '%c'\n", *p);
                print_usage();
                exit(1);
            }
            p++;
        }

        // Reset pointer and set flags
        p = &argv[1][1];
        while (*p) {
            if (*p == 'l') show_lines = 1;
            else if (*p == 'w') show_words = 1;
            else if (*p == 'c') show_chars = 1;
            else if (*p == 'L') show_max_line = 1;
            p++;
        }
        file_start = 2;
    }

    // If no flags specified, show all three (lines, words, chars)
    if (!has_flags) {
        show_lines = show_words = show_chars = 1;
    }

    // If all flags are off (possible with empty - ""), show default
    if (!show_lines && !show_words && !show_chars && !show_max_line) {
        show_lines = show_words = show_chars = 1;
    }

    // Handle no files case
    if (file_start >= argc) {
        printf("wc: missing file operand\n");
        printf("Try 'wc ?' for more information.\n");
        exit(1);
    }

    int total_lines = 0, total_words = 0, total_chars = 0, total_max_line = 0;
    int file_count = 0;

    for (int i = file_start; i < argc; i++) {
        int fd = open(argv[i], O_RDONLY);
        if (fd < 0) {
            printf("wc: cannot open '%s'\n", argv[i]);
            continue;
        }

        int lines = 0, words = 0, chars = 0;
        int max_line = 0, curr_line = 0;
        int in_word = 0;
        char ch;
        int last_char_was_newline = 0;

        while (read(fd, &ch, 1) == 1) {
            chars++;  // Count EVERY character

            // Track line length for max_line calculation
            if (ch == '\n') {
                lines++;  // Count line when we see newline

                // Line length is current line count BEFORE resetting
                if (curr_line > max_line) {
                    max_line = curr_line;
                }
                curr_line = 0;  // Reset for next line
                last_char_was_newline = 1;
            } else {
                curr_line++;  // Count character in current line
                last_char_was_newline = 0;
            }

            // Word counting logic
            if (ch == ' ' || ch == '\n' || ch == '\t' || ch == '\r') {
                in_word = 0;
            } else if (!in_word) {
                words++;
                in_word = 1;
            }
        }

        // BUG FIX #1: Handle last line if file doesn't end with newline
        if (chars > 0 && !last_char_was_newline) {
            lines++;  // Last line doesn't have terminating newline
            if (curr_line > max_line) {
                max_line = curr_line;
            }
        }

        // BUG FIX #2: Handle empty file case
        if (chars == 0) {
            lines = 0;
            words = 0;
            max_line = 0;
        }

        close(fd);

        // Print according to flags
        if (show_lines) printf("%d ", lines);
        if (show_words) printf("%d ", words);
        if (show_chars) printf("%d ", chars);
        if (show_max_line) printf("%d ", max_line);
        printf("%s\n", argv[i]);

        total_lines += lines;
        total_words += words;
        total_chars += chars;
        if (max_line > total_max_line)
            total_max_line = max_line;

        file_count++;
    }

    // Print total if multiple files
    if (file_count > 1) {
        if (show_lines) printf("%d ", total_lines);
        if (show_words) printf("%d ", total_words);
        if (show_chars) printf("%d ", total_chars);
        if (show_max_line) printf("%d ", total_max_line);
        printf("total\n");
    }

    exit(0);
}
