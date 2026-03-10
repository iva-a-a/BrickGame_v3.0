#pragma once

#include <QTimer>

#include "../../brick_game/api/struct.h"
#include "Drawing.hpp"

class GameWidget : public Drawing {
  Q_OBJECT

public:
  enum class Mode { StartScreen, Playing, GameOver };

  GameWidget(QMainWindow *parent, int tickMs = 30);

protected:
  void paintEvent(QPaintEvent *e) override;
  void keyPressEvent(QKeyEvent *e) override;
  void keyReleaseEvent(QKeyEvent *e) override;

private:
  void onTick();
  void startOrRestartNow();
  UserAction_t mapKey(QKeyEvent *e) const;

private:
  QTimer *timer_{nullptr};

  Mode mode_{Mode::StartScreen};
  GameInfo_t last_{};
};
