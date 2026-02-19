#pragma once

#include <QMainWindow>
#include <QPainter>
#include <QWidget>

#define SIZE_RECT 30

class Drawing : public QWidget {
 public:
  explicit Drawing(QMainWindow* w) : parent_{w} {};
  ~Drawing() = default;

 protected:
  void setupWindow();
  void setupPainter(QPainter& p);

  void drawMatrix(int** m, int rows, int cols, QPainter& p, int offX, int offY);
  void drawBoard(QPainter& p);
  void drawStart(QPainter& p);
  void drawPause(QPainter& p);
  void drawGameover(QPainter& p);
  void drawBannerStat(QPainter& p, int level, int speed, int score,
                      int h_score);
  QMainWindow* parent_;
};
