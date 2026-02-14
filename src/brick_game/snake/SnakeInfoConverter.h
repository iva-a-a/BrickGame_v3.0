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
    static GameInfo_t toGameInfo(const SnakeInfo& info);
    
private:
    static void listToArray(const std::list<Coordinate>& l);
    static void coordinateToArray(Coordinate c);
};
