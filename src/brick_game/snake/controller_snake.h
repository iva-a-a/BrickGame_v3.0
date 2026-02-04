#pragma once

#include "model_snake.h"

class Controller {
public:
    Controller() = default;
    ~Controller() = default;
    
    void userInput(UserAction_t currentAction, bool hold);
    GameInfo_t updateCurrentState();
    void clearGameInfo(GameInfo_t &info_snake);
    
    SnakeGame *get_model();
private:
    SnakeGame model;
    
    int **convert_snake_to_array(std::list<Coordinate> snake);
    int **convert_apple_to_array(Coordinate apple);
    void free_array(int **array);
};
