#pragma once

#include <QKeyEvent>
#include <QTimer>

#include "../../brick_game/snake/controller_snake.h"
#include "desktop.h"

class SnakeWidget : public CommonDraw {
  Q_OBJECT
 public:
  explicit SnakeWidget(QMainWindow *parent);
  ~SnakeWidget();

  void draw_win(QPainter &p);

 protected:

  void keyPressEvent(QKeyEvent *key) override;

  void paintEvent(QPaintEvent *event) override;

 private:
  Controller controller;
  QTimer *timer;

 private slots:
  void update_display();
};