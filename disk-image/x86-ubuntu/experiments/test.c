#include <fcntl.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

#define CXL_ADDR_LOW 0x100000000
#define CXL_ADDR_HIGH 0x300000000

int main() {
  int mfd = open("/dev/mem", O_RDWR);
  if (mfd < 0) {
    perror("open");
    return 1;
  }

  void *cxl_map = mmap(NULL, CXL_ADDR_HIGH - CXL_ADDR_LOW,
                       PROT_READ | PROT_WRITE, MAP_SHARED, mfd, CXL_ADDR_LOW);
  if (cxl_map == MAP_FAILED) {
    perror("mmap");
    return 1;
  }

  printf("mmaped cxl successfully\n");
  return 0;
}
