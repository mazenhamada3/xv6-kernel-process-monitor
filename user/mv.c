#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(2, "Usage: mv source destination\n");
        exit(1);
    }

    if (argv[1][0] == '?') {
        printf("Usage: mv source destination\n");
        printf("Move or rename source file to destination\n");
        exit(0);
    }

    struct stat st;
    char dest_path[512];

    // Check if source exists
    if (stat(argv[1], &st) < 0) {
        fprintf(2, "mv: cannot move %s\n", argv[1]);
        exit(1);
    }

    // Check if destination is a directory
    if (stat(argv[2], &st) == 0 && (st.type == T_DIR)) {
        // Destination is a directory, move file into it
        char *src_name = argv[1];
        // Extract just the filename from source path
        for(char *p = argv[1]; *p; p++) {
            if(*p == '/') {
                src_name = p + 1;
            }
        }

        // Build destination path: dirname/filename
        strcpy(dest_path, argv[2]);
        int len = strlen(dest_path);
        if(dest_path[len-1] != '/') {
            dest_path[len] = '/';
            dest_path[len+1] = '\0';
        }
        strcpy(dest_path + strlen(dest_path), src_name);
    } else {
        // Destination is a file or doesn't exist
        strcpy(dest_path, argv[2]);
    }

    if (link(argv[1], dest_path) < 0) {
        fprintf(2, "mv: cannot move %s\n", argv[1]);
        exit(1);
    }

    if (unlink(argv[1]) < 0) {
        fprintf(2, "mv: failed to remove original file %s\n", argv[1]);
        // Try to clean up the link we created
        unlink(dest_path);
        exit(1);
    }

    exit(0);
}
