#include "SnakeGame.h"

#include <algorithm>

SnakeGame::SnakeGame(const HighScoreStorage* storage) : storage_(storage) {
  srand(static_cast<unsigned int>(time(NULL)));
    highScore_ = storage_ ? storage_->load() : 0;
    clearingGame();
}

SnakeInfo SnakeGame::getInfo() const {
  SnakeInfo info{};
  info.state = state_;

  info.score = score_;
  info.high_score = highScore_;
  info.level = level_;
  info.speed = speed_;
  info.pause = (state_ == Break);

  info.apple = apple_;
info.snake = snake_.getBody();

  return info;
}

void SnakeGame::clearingGame() {
    score_ = 0;
    level_ = 1;
    speed_ = 500;
    prevTime_ = 0;

    currentAction_ = None;
    state_ = Begin;
    snake_.reset();
}

void SnakeGame::putApple() {
  bool appleIsFree;
  do {
      int x = rand() % COL_BOARD;
      int y = rand() % ROWS_BOARD;
      apple_ = {x, y};

      const auto& body = snake_.getBody();
      appleIsFree =
        std::none_of(body.begin(), body.end(),
                     [this](const auto &i) { return apple_.eqCoordinate(i); });
  } while (!appleIsFree);
}

bool SnakeGame::isCollision(const Coordinate &pos) const {
    if (pos.x < 0 || pos.x >= COL_BOARD || pos.y < 0 || pos.y >= ROWS_BOARD) {
      return true;
    }
  return snake_.hitsSelf(pos);
}

void SnakeGame::checkMoveSnake() {
  long long int time = time_in_millisec();

  if (time - prevTime_ > speed_) {
      moveSnake();
      prevTime_ = time;
  }
}

void SnakeGame::moveSnake() {
  Coordinate next = snake_.nextHeadPos();

  if (isCollision(next)) {
      state_ = End;
    return;
  }

  bool grow = (next == apple_);
  snake_.move(grow);

  if (grow) {
      score_++;
    if (score_ == SCORE_WIN) {
        state_ = End;
    } else {
        state_ = Attaching;
    }
  }
}

void SnakeGame::changeDirection(UserAction_t action) {
  if (action == Up) snake_.setDirection(Direction::Up);
  else if (action == Down) snake_.setDirection(Direction::Down);
  else if (action == Left) snake_.setDirection(Direction::Left);
  else if (action == Right) snake_.setDirection(Direction::Right);
}


void SnakeGame::increaseLevel() {
  while (score_ >= level_ * LEVEL_NEXT_SNAKE && level_ != MAX_LEVEL) {
    if (level_ < MAX_LEVEL) {
        level_++;
        speed_ -= 50;
    }
  }
}

void SnakeGame::saveHighScore() {
  if (score_ >= highScore_) {
      highScore_ = score_;
      if (storage_) storage_->save(highScore_);
  }
}

void SnakeGame::update() {
  if (state_ == Begin || state_ == Exit || state_ == End) return;

  if (state_ == Generation) {
    prevTime_ = time_in_millisec();
    putApple();
    state_ = Falling;
  } else if (state_ == Falling) {
    checkMoveSnake();
  } else if (state_ == Moving_rotate) {
    changeDirection(currentAction_);
    state_ = Falling;
  } else if (state_ == Attaching) {
    increaseLevel();
    saveHighScore();
    state_ = Generation;
  }
}

void SnakeGame::fsm(UserAction_t action, bool hold) {
  if (action == Start && state_ == Begin) {
      clearingGame();
      state_ = Generation;
  } else if (state_ == Falling) {
    if (action == Pause) {
        state_ = Break;
    } else if (action == Left || action == Right || action == Up || action == Down) {
      if (hold) {
        moveSnake();
      } else {
        currentAction_ = action;
        state_ = Moving_rotate;
      }
    } else if (action == Terminate) {
        state_ = End;
    }
  } else if (state_ == Break) {
    if (action == Pause) {
        state_ = Falling;
    } else if (action == Terminate) {
        state_ = End;
    }
  } else if (state_ == End) {
    if (action == Start) {
        state_ = Begin;
    } else if (action == Terminate) {
        state_ = Exit;
    }
  }
}
