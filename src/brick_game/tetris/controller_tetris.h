#ifndef CONTROLLER_TETRIS_H
#define CONTROLLER_TETRIS_H

#ifdef __cplusplus
extern "C" {
#endif

#include "back_tetris.h"

GameInfo_t tetris_updateCurrentState();

void tetris_userInput(UserAction_t action, bool hold);

#ifdef __cplusplus
}
#endif

#endif
