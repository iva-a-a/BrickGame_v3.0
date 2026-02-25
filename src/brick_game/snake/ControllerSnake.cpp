#include "ControllerSnake.h"
#include "SnakeInfoConverter.h"

void Controller::userInput(UserAction_t currentAction, bool hold) {
  model_.fsm(currentAction, hold);
}

GameInfo_t Controller::updateCurrentState() {
  model_.update();
  SnakeInfo info = model_.getInfo();
  return SnakeInfoConverter::toGameInfo(info);
}
