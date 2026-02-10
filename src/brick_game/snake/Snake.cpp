//
//  Snake.cpp
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#include "Snake.h"
#include <iterator>

Snake::Snake() { reset(); }

void Snake::reset() {
    body_ = {{18, 5}, {17, 5}, {16, 5}, {15, 5}};
    dir_ = Direction::Up;
}

const std::list<Coordinate>& Snake::getBody() const { return body_; }

Direction Snake::getDirection() const { return dir_; }

void Snake::setDirection(Direction dir) {
    if (!isOpposite(dir_, dir)) {
        dir_ = dir;
    }
}

bool Snake::hitsSelf(const Coordinate& pos) const {
  if (body_.size() < 2) return false;
  auto last = std::prev(body_.end());
  for (auto it = body_.begin(); it != last; ++it) {
    if (pos == *it) return true;
  }
  return false;
}

Coordinate Snake::nextHeadPos() const {
    Coordinate pos = body_.back();
    switch (dir_) {
      case Direction::Up:
        pos.x--;
        break;
      case Direction::Down:
        pos.x++;
        break;
      case Direction::Left:
        pos.y--;
        break;
      case Direction::Right:
        pos.y++;
    }
    return pos;
}

void Snake::move(bool grow) {
    body_.push_back(nextHeadPos());
    if (!grow) body_.pop_front();
}
