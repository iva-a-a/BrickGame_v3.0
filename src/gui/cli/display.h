#ifndef DISPLAY_H
#define DISPLAY_H

#include <ncurses.h>

#include "../../brick_game/api/struct.h"

#ifdef __cplusplus
extern "C" {
#endif

void setup_gui();
void delete_gui();

UserAction_t input_key();

#ifdef __cplusplus
}
#endif

#endif
