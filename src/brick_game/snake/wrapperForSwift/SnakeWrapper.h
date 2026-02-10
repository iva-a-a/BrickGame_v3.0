#ifndef SNAKE_WRAPPER_H
#define SNAKE_WRAPPER_H

#include "stdbool.h"
#include "../../struct.h"

#ifdef __cplusplus
extern "C" {
#endif

GameInfo_t snake_updateCurrentState();

void snake_userInput(UserAction_t action, bool hold);

#ifdef __cplusplus
}
#endif

#endif

