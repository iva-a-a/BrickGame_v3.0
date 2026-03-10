#include "SnakeWrapper.h"
#include "../ControllerSnake.h"

static Controller* getPtrControllerSnake() {
    static Controller snake_controller;
    return &snake_controller;
}

static void resetPtrControllerSnake() {
    Controller* controller = getPtrControllerSnake();
    controller->~Controller();
    new (controller) Controller();
}

void snake_userInput(UserAction_t action, bool hold) {
    if (action == Start) {
        resetPtrControllerSnake();
    }
    getPtrControllerSnake()->userInput(action, hold);
}

GameInfo_t snake_updateCurrentState() {
  GameInfo_t info = getPtrControllerSnake()->updateCurrentState();
  return info;
}
