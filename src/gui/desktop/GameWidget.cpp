#include "GameWidget.hpp"
#include "../../brick_game/api/apiBG.h"

#include <QKeyEvent>

static constexpr int ROWS_BOARD = 20;
static constexpr int COL_BOARD = 10;
static constexpr int ROWS_FIGURE = 4;
static constexpr int COL_FIGURE = 4;

GameWidget::GameWidget(QMainWindow *parent, int tickMs) : Drawing(parent) {
  setupWindow();

  timer_ = new QTimer(this);
  connect(timer_, &QTimer::timeout, this, [this] { onTick(); });
  timer_->start(tickMs);
}

void GameWidget::onTick() {
  if (mode_ != Mode::Playing) {
    return;
  }

  last_ = updateCurrentState();

  if (last_.next == nullptr) {
    mode_ = Mode::GameOver;
  }
  update();
}

void GameWidget::paintEvent(QPaintEvent *e) {
  Q_UNUSED(e)
  QPainter p(this);
  setupPainter(p);

  QColor gameBackground(170, 170, 170);
  p.fillRect(rect(), gameBackground);
  p.setPen(Qt::black);

  if (mode_ == Mode::StartScreen) {
    p.setPen(Qt::white);
    drawStart(p);
    return;
  }

  drawBoard(p);

  if (last_.field) {
    drawMatrix(last_.field, ROWS_BOARD, COL_BOARD, p, 0, 0);
  }

  int offX = SIZE_RECT * 10 + 10;
  int offY = SIZE_RECT * 2;
  if (last_.next) {
    drawMatrix(last_.next, ROWS_FIGURE, COL_FIGURE, p, offX, offY);
  }

  p.setPen(Qt::white);
  drawBannerStat(p, last_.level, last_.speed, last_.score, last_.high_score);

  if (mode_ == Mode::GameOver) {
    drawGameover(p);
  } else if (last_.pause) {
    drawPause(p);
  }
}

UserAction_t GameWidget::mapKey(QKeyEvent *e) const {
  switch (e->key()) {
  case Qt::Key_Down:
    return Down;
  case Qt::Key_Up:
    return Up;
  case Qt::Key_Left:
    return Left;
  case Qt::Key_Right:
    return Right;
  case Qt::Key_Return:
  case Qt::Key_Enter:
    return Start;
  case Qt::Key_Escape:
    return Terminate;
  case Qt::Key_Backspace:
    return Pause;
  case Qt::Key_Space:
    return Action;
  default:
    return None;
  }
}

void GameWidget::keyPressEvent(QKeyEvent *e) {
  UserAction_t act = mapKey(e);
  if (act == Terminate) {
    userInput(Terminate, false);
    close();
    parent_->show();
    return;
  }

  if (mode_ == Mode::StartScreen) {
    if (act == Start) {
      startOrRestartNow();
    }
    return;
  }

  if (mode_ == Mode::GameOver) {
    if (act == Start) {
      startOrRestartNow();
    }
    return;
  }
  if (act != None) {
    userInput(act, e->isAutoRepeat());
  }
  update();
}

void GameWidget::startOrRestartNow() {
  userInput(Start, false);
  mode_ = Mode::Playing;
  last_ = updateCurrentState();
  update();
}

void GameWidget::keyReleaseEvent(QKeyEvent *e) { Q_UNUSED(e) }
