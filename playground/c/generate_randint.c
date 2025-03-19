#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
  srand((unsigned)time(NULL));
  uint32_t a1, a2;
  printf("First randint: %d\n", rand());
  a1 = (uint32_t)rand();
  a2 = a1 & 0xffffu + 0x10000u;
  printf("a1: %x\na2: %x", a1, a2);

  return 0;
}
