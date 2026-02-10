#pragma once

#include "SnakeGame.h"
#include "HighScoreStorage.h"

class Controller {
public:
    Controller() : storage_(), model_(&storage_) {}
    ~Controller() = default;
    
    void userInput(UserAction_t currentAction, bool hold);
    GameInfo_t updateCurrentState();

private:
    HighScoreStorage storage_;
    SnakeGame model_;
};
