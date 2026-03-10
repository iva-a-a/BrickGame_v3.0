#include "SnakeWrapper.h"
#include "../ControllerSnake.h"

static Controller* getPtrControllerSnake() {
    static Controller snake_controller;
    return &snake_controller;
}

void snake_userInput(UserAction_t action, bool hold) {
    getPtrControllerSnake()->userInput(action, hold);
}

GameInfo_t snake_updateCurrentState() {
  GameInfo_t info = getPtrControllerSnake()->updateCurrentState();
  return info;
}
