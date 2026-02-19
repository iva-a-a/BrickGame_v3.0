#include "GameWidget.hpp"

#include <QKeyEvent>

static constexpr int ROWS_BOARD = 20;
static constexpr int COL_BOARD  = 10;

GameWidget::GameWidget(QMainWindow* parent, GameApiQt api, int tickMs)
  : Drawing(parent), api_(std::move(api)) {

  setupWindow();

  timer_ = new QTimer(this);
  connect(timer_, &QTimer::timeout, this, [this]{ onTick(); });
  timer_->start(tickMs);
}

void GameWidget::onTick() {
  if (mode_ == Mode::StartScreen) return;

  last_ = api_.update();

  // как в консоли: next == NULL => game over
  if (mode_ == Mode::Playing && last_.next == nullptr) {
    mode_ = Mode::GameOver;
  }

  update();
}

void GameWidget::paintEvent(QPaintEvent* e) {
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

  if (api_.drawNext) {
    int offX = SIZE_RECT * 10 + 10;
    int offY = SIZE_RECT * 2;
    if (last_.next) {
      drawMatrix(last_.next, 4, 4, p, offX, offY);
    }
    p.setPen(Qt::white);
    p.drawText(offX, SIZE_RECT, "Next:");
  }

  p.setPen(Qt::white);
  drawBannerStat(p,
                 last_.level,
                 last_.speed,
                 last_.score,
                 last_.high_score);

  if (mode_ == Mode::GameOver) {
    drawGameover(p);
  } else if (last_.pause) {
    drawPause(p);
  }
}


UserAction_t GameWidget::mapKey(QKeyEvent* e) const {
  switch (e->key()) {
    case Qt::Key_Down: return Down;
    case Qt::Key_Up: return Up;
    case Qt::Key_Left: return Left;
    case Qt::Key_Right: return Right;
    case Qt::Key_Return:
    case Qt::Key_Enter: return Start;
    case Qt::Key_Escape: return Terminate;
    case Qt::Key_Backspace: return Pause;
    case Qt::Key_Space: return Action;
    default: return None;
  }
}

void GameWidget::keyPressEvent(QKeyEvent* e) {
  UserAction_t act = mapKey(e);

  // ESC = exit (как в консоли)
  if (act == Terminate) {
    api_.input(Terminate, false);
    close();
    parent_->show();
    return;
  }

  if (mode_ == Mode::StartScreen) {
    if (act == Start) {
      api_.input(Start, false);
      mode_ = Mode::Playing;
    }
    update();
    return;
  }

  if (mode_ == Mode::GameOver) {
    if (act == Start) {
      api_.input(Start, false);
      prev_ = None;
      mode_ = Mode::Playing;
    }
    update();
    return;
  }

  // Playing
  if (act != None) {
    bool hold = false;
    if (api_.useHold) {
      hold = (act == prev_);
      prev_ = act;
    }
    api_.input(act, hold);
  }

  update();
}
