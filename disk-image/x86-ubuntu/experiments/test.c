#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

#define BASE 0x8000000000000000
#define CXL_ADDR_LOW 0x100000000
#define CXL_ADDR_HIGH 0x300000000

int main() {
  int mfd = open("/dev/mem", O_RDWR);
  if (mfd < 0) {
    perror("open");
    return 1;
  }

  volatile void *cxl_map =
      mmap(NULL, CXL_ADDR_HIGH - CXL_ADDR_LOW, PROT_READ | PROT_WRITE,
           MAP_SHARED, mfd, CXL_ADDR_LOW + BASE);
  if (cxl_map == MAP_FAILED) {
    perror("mmap");
    return 1;
  }

  printf("mmaped cxl successfully\n");

  volatile int *cxl = (int *)cxl_map;
  for (int i = 0; i < 10; i++) {
    int val = i * 2;
    printf("trying to set cxl[%d] => %d\n", i, val);
    cxl[i] = val;
  }
  for (int i = 0; i < 10; i++)
    printf("cxl[%d] = %d\n", i, cxl[i]);

  return 0;
}
