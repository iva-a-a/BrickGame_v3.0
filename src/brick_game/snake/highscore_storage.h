//
//  highscore_storage.h
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#pragma once

#include <string>
#include <string_view>

class HighScoreStorage {
public:
    HighScoreStorage() : fileName_(defaultFileName_) {}
    
    void save(int value) const;
    int load() const;
    
private:
    std::string fileName_;
    static constexpr std::string_view defaultFileName_ = "highscore_snake.txt";
};


