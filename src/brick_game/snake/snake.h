//
//  snake.h
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//
#pragma once
#include "coordinate.h"
#include <list>

enum class Direction {
  Up,
  Down,
  Right,
  Left
};

constexpr bool isOpposite(Direction a, Direction b) {
  return (a == Direction::Up && b == Direction::Down) ||
         (a == Direction::Down && b == Direction::Up) ||
         (a == Direction::Left && b == Direction::Right) ||
         (a == Direction::Right && b == Direction::Left);
}

class Snake {
public:
    Snake();
    ~Snake() = default;
    
    void reset();
    
    const std::list<Coordinate>& getBody() const;
    Direction getDirection() const;
    
    void setDirection(Direction dir);
    
    bool hitsSelf(const Coordinate& pos) const;
    Coordinate nextHeadPos() const;
    void move(bool grow);
    
private:
    std::list<Coordinate> body_;
    Direction dir_;
};
