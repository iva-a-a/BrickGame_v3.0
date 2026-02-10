#include <cstdlib>
#include <ctime>
#include <iostream>
#include <list>

#include "../defines.h"
//#include "../struct.h"
#include "highscore_storage.h"
//#include "coordinate.h"
#include "snake.h"
#include "SnakeInfo.h"

class SnakeGame {
public:
    explicit SnakeGame(const HighScoreStorage* storage = nullptr);
    ~SnakeGame() = default;
    
    SnakeInfo getInfo() const;
    

    void update();
    void fsm(UserAction_t action, bool hold);

private:
    Snake snake_;
    Coordinate apple_;
    
    const HighScoreStorage* storage_ = nullptr;
    
    GameState_t state_;
    UserAction_t currentAction_;
    long long int prevTime_;
    int score_;
    int highScore_;
    int level_;
    int speed_;

    void moveSnake();
    void putApple();
    void checkMoveSnake();
    void changeDirection(UserAction_t currentAction);
    bool isCollision(const Coordinate &pos) const;
    void increaseLevel();
    void saveHighScore();

    void clearingGame();
};
