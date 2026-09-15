/*
 * mf — chattr replacement via FS_IOC_SETFLAGS ioctl
 * Lernaean Siege KoTH
 *
 * Compile: gcc -O2 -s -static mf.c -o <name> && strip <name>
 * Run:     ./<name> <file> <flag>    (16 = immutable on, 0 = off)
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <linux/fs.h>

int main(int argc, char **argv) {
    if (argc < 3) return 1;
    FILE *fp = fopen(argv[1], "r");
    if (!fp) return 1;
    int val = atoi(argv[2]);
    ioctl(fileno(fp), FS_IOC_SETFLAGS, &val);
    fclose(fp);
    return 0;
}
