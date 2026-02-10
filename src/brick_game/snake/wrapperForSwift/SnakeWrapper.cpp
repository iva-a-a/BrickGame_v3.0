#include "SnakeWrapper.h"
#include "../ControllerSnake.h"

static Controller snake_controller;

void snake_userInput(UserAction_t action, bool hold) {
    snake_controller.userInput(action, hold);
}

GameInfo_t snake_updateCurrentState() {
  GameInfo_t info = snake_controller.updateCurrentState();
  return info;
}
