//
//  HighScoreStorage.cpp
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#include "HighScoreStorage.h"
#include <fstream>

void HighScoreStorage::save(int value) const {
    std::ofstream out(fileName_, std::ios::trunc);
    if (out) {
      out << value;
    }
}

int HighScoreStorage::load() const {
    std::ifstream in(fileName_);
    int value = 0;
    if (in) {
      in >> value;
    }
    return value;
}
