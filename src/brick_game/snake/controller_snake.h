#pragma once

#include "model_snake.h"
#include "highscore_storage.h"

class Controller {
public:
    Controller() : storage_(), model_(&storage_) {}
    ~Controller() = default;
    
    void userInput(UserAction_t currentAction, bool hold);
    GameInfo_t updateCurrentState();
    
    void clearGameInfo(GameInfo_t& info);

private:
    HighScoreStorage storage_;
    SnakeGame model_;
};
