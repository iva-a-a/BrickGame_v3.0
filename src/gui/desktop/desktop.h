#pragma once

#include <QColor>
#include <QMainWindow>
#include <QPainter>
#include <QWidget>

#define SIZE_RECT 30

class CommonDraw : public QWidget {
 public:
  explicit CommonDraw(QMainWindow *w) : parent{w} {};

  ~CommonDraw() = default;

  void setup_window();
  void setup_painter(QPainter &p);

  QColor get_color(int c);

  void draw_arr(int **arr, QPainter &p);
  void draw_board(QPainter &p);
  void draw_start(QPainter &p);
  void draw_pause(QPainter &p);
  void draw_gameover(QPainter &p);
  void draw_banner_stat(QPainter &p, int level, int speed, int score,
                        int h_score, int begin_speed);

 protected:
  QMainWindow *parent;
};
