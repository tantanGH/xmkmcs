#include <stdio.h>
#include <stdint.h>
#include <process.h>
#include <doslib.h>

int32_t main(int32_t argc, uint8_t* argv[]) {

  // default return code
  int32_t rc = -1;

  // argument check
  if (argc < 2) {
    printf("usage: kflush <exec-file> [exec-options]\n");
    goto exit;
  }

  // child process execution
  if (spawnvp(P_WAIT, argv[1], (const char**)(argv+1)) < 0) {
    printf("error: process execution error.\n");
    goto exit;
  }

  // key flush
  KFLUSHIO(0xff);

  // success
  rc = 0;

exit:
  return rc;
}