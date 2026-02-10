//
//  SnakeInfoConverter.h
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#pragma once
#include "SnakeInfo.h"

class SnakeInfoConverter {
public:
    static GameInfo_t toGameInfo(const SnakeInfo info);
    static void freeGameInfo(GameInfo_t& info);
    
private:
    static int **listToArray(std::list<Coordinate> l);
    static int **coordinateToArray(Coordinate c);
    static void freeArray(int **array);
};
