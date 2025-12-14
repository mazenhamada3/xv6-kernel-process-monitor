#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int isnumber(char *s) {
    // Allow optional leading + or -
    if (*s == '-' || *s == '+')
        s++;

    // Empty string or only sign is NOT a number
    if (*s == '\0')
        return 0;

    // Ensure all remaining characters are digits
    for (; *s; s++) {
        if (*s < '0' || *s > '9')
            return 0;
    }
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(2, "Usage: add number1 number2\n");
        exit(1);
    }

    if (argv[1][0] == '?') {
        printf("Usage: add number1 number2\n");
        printf("Add two integers and print the result\n");
        exit(0);
    }

    // Validate both arguments
    if (!isnumber(argv[1]) || !isnumber(argv[2])) {
        printf("Invalid number\n");
        exit(1);
    }

    int num1 = atoi(argv[1]);
    int num2 = atoi(argv[2]);
    int result = num1 + num2;

    printf("%d + %d = %d\n", num1, num2, result);
    exit(0);
}
