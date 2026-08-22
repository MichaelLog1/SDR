#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <signal.h>

#define DMA_BASE 0x40400000UL
#define BUF_PHYS 0x1E000000UL
#define MAP_SIZE 0x1000UL
#define NUM_DESCRIPTORS 8
// one page for descriptors, then 8 buffers for DMA
#define BUF_SIZE (0x1000UL + (NUM_DESCRIPTORS * 0x1000UL))

#define DMA_SIZE 4096

#define S2MM_DMACR (0x30/4)
#define S2MM_DMASR (0x34/4)
#define S2MM_CURDESC (0x38/4)
#define S2MM_TAILDESC (0x40/4)

int main() {
        // ignore sigpipes
        signal(SIGPIPE, SIG_IGN);

        // setup tcp socket
        int listen_fd = socket(AF_INET, SOCK_STREAM, 0);
        if (listen_fd < 0) {
                perror("listen");
                return 1;
        }

        // for restarting
        int one = 1;
        setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));

        struct sockaddr_in addr = {0};
        addr.sin_family = AF_INET;
        addr.sin_port = htons(1234);
        addr.sin_addr.s_addr = htonl(INADDR_ANY);
        bind(listen_fd, (struct sockaddr*)&addr, sizeof(addr));

        listen(listen_fd, 1);

        // block until a connection arrives
        printf("Waiting for connection...\n");
        int connection_fd = accept(listen_fd, NULL, NULL);
        printf("Connection found...\n");

        int fd = open("/dev/mem", O_RDWR | O_SYNC);
        if (fd < 0) {
                perror("open");
                return 1;
        }

        volatile uint32_t *dma = mmap(NULL, MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, DMA_BASE);
        volatile uint32_t *buf = mmap(NULL, BUF_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, BUF_PHYS);

        if (dma == MAP_FAILED || buf == MAP_FAILED) {
                perror("mmap");
                return 1;
        }

        // set up descriptors
        for (int i = 0; i < NUM_DESCRIPTORS; i++) {
                volatile uint32_t *d = buf + 0x10 * i;
                d[0] = BUF_PHYS + 0x40*((i+1) % 8); // next descriptor
                d[1] = 0; // next descriptor MSB
                d[2] = BUF_PHYS + 0x1000 + 0x1000 * i; // buffer address
                d[3] = 0; // buffer address MSB
                d[6] = DMA_SIZE; // buffer length
                d[7] = 0; // clear status
        }

        dma[S2MM_DMACR] = 0x4;
        while(dma[S2MM_DMACR] & 0x4);
        dma[S2MM_CURDESC] = BUF_PHYS; // descriptor 0
        dma[S2MM_DMACR] = 0x1 | 0x10; // enable cyclic
        dma[S2MM_TAILDESC] = 0x50; // should be impossible

        int i = 0;
        while (1) {
                volatile uint32_t *status = buf + 0x10*i + 7; // descriptor i status word
                //while (!(*status & 0x80000000)); // wait for complete bit
                long spins = 0;
                while (!(*status & 0x80000000)) {
                        if (++spins == 50000000) {
                                printf("stuck desc%d: DMASR=0x%08x DMACR=0x%08x CURDESC=0x%08x sts=0x%08x\n", i, dma[S2MM_DMASR], dma[S2MM_DMACR], dma[S2MM_CURDESC], *status);
                                spins = 0;
                        }
                }

                volatile uint32_t *frame = buf + 0x400 + 0x400 * i;

                // process frame
                int sent = 0;
                while (sent < 4096) {
                        int n = send(connection_fd, (char*)frame + sent, 4096 - sent, 0);
                        if (n <= 0) {
                                close(connection_fd);
                                connection_fd = accept(listen_fd, NULL, NULL);
                                sent = 0; // restart this frame
                                continue;
                        }
                        sent += n;
                }

                *status = 0;
                printf("[%d] 0x%08x I=%6d Q=%6d\n", i, *frame, (int16_t)(*frame>>16), (int16_t)(*frame & 0xFFFF));
                i = (i + 1) % NUM_DESCRIPTORS;
                }
        return 0;
}