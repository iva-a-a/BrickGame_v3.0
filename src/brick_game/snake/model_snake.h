#include <cstdlib>
#include <ctime>
#include <fstream>
#include <iostream>
#include <list>

#include "../defines.h"
#include "../struct.h"


enum class Direction {
  Up,
  Down,
  Right,
  Left
};

struct Coordinate {
  int x;
  int y;

  bool eq_coordinate(const Coordinate &a) const {
    return (x == a.x && y == a.y);
  }

  bool operator==(const Coordinate &a) const { return eq_coordinate(a); }
};


class SnakeGame {
public:
    SnakeGame();
    ~SnakeGame() = default;
    
    void set_state(GameState_t state);
    void set_currAction(UserAction_t currentAction);
    GameState_t get_state() const;
    UserAction_t get_currAction();
    std::list<Coordinate> &get_snake();
    Coordinate get_apple();
    int get_score();
    int get_high_score();
    int get_level();
    int get_speed();
    
    void move_snake();
    void update();

private:
    std::list<Coordinate> snake;
    Coordinate apple;
    
    int s_score;
    Direction dir;
    GameState_t state;
    UserAction_t currentAction;
    long long int prev_time;
    
    int s_high_score;
    int s_level;
    int s_speed;
    
    void set_prev_time(long long int time);

    void put_apple();
    void create_snake();

    Coordinate snake_head_new_pos();
    void check_move_snake();
    void change_direction(UserAction_t currentAction);
    bool collision(const Coordinate &pos);
    void increase_level();

    void save_high_score();

    void clearing_game();
    void initial_info();
};
