#include "Drawing.hpp"

#include <QBrush>
#include <QColor>
#include <QFont>

#include <iomanip>
#include <sstream>
#include <string>

void Drawing::setupWindow() {
  setFixedSize(SIZE_RECT * 10 + 200, SIZE_RECT * 20 + 10);
  setFocusPolicy(Qt::StrongFocus);
}

void Drawing::setupPainter(QPainter &p) {
  QFont font;
  font.setPointSize(14);
  p.setFont(font);
}

void Drawing::drawMatrix(int **m, int rows, int cols, QPainter &p, int offX, int offY) {
  p.fillRect(rect(), Qt::white);
  if (!m) return;
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      int v = m[i][j];
      if (v == 0) continue;
      p.fillRect(offX + j * SIZE_RECT, offY + i * SIZE_RECT, SIZE_RECT, SIZE_RECT, QBrush(QColor(Qt::black)));
      p.drawRect(offX + j * SIZE_RECT, offY + i * SIZE_RECT, SIZE_RECT, SIZE_RECT);
    }
  }
}


void Drawing::drawBoard(QPainter &p) {
  for (int x = 0; x < SIZE_RECT * 10; x += SIZE_RECT) {
    for (int y = 0; y < SIZE_RECT * 20; y += SIZE_RECT) {
      p.drawRect(x, y, SIZE_RECT, SIZE_RECT);
    }
  }
}

void Drawing::drawStart(QPainter &p) {
  p.drawText(rect(), Qt::AlignCenter, "Press ENTER to Start");
}

void Drawing::drawPause(QPainter &p) {
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 10 + 25, "PAUSE");
}
void Drawing::drawGameover(QPainter &p) {
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 10 + 25, "GAME OVER!");
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 19 + 25, "ENTER - restart");
}

void Drawing::drawBannerStat(QPainter &p, int level, int speed, int score,
                                  int h_score, int begin_speed) {
  std::string l = "Level: " + std::to_string(level);
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 4 + 25, l.data());

  float speedSn = (float)begin_speed / speed;
  std::ostringstream oss;
  oss << std::fixed << std::setprecision(2) << speedSn;
  std::string sp = "Speed: " + oss.str();
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 5 + 25, sp.data());

  std::string s = "Score: " + std::to_string(score);
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 6 + 25, s.data());

  std::string hs = "High score: " + std::to_string(h_score);
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 7 + 25, hs.data());

  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 14 + 25, "     Press:");
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 15 + 25, "ESC - exit");
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 16 + 25, "BACKSPACE - pause");
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 17 + 25, "ARROWS - move");
  p.drawText(SIZE_RECT * 10 + 5, SIZE_RECT * 18 + 25, "SPACE - action");
}