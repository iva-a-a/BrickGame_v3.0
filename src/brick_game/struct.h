#ifndef STRUCT_H
#define STRUCT_H

#include <sys/time.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {

  Start = 10,
  Pause,
  Terminate,
  Left,
  Right,
  Up,
  Down,
  Action,
  None
} UserAction_t;

typedef enum {
  Begin,
  Generation,
  Falling,
  Break,
  Moving_rotate,
  Moving_left,
  Moving_right,
  Moving_down,
  Attaching,
  End,
  Exit
} GameState_t;

typedef struct {
  int **field;
  int **next;
  int score;
  int high_score;
  int level;
  int speed;
  int pause;
} GameInfo_t;

static inline long long int time_in_millisec(void) {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (((long long int)tv.tv_sec) * 1000) + (tv.tv_usec / 1000);
}

#ifdef __cplusplus
}
#endif

#endif
