#pragma once

#include "Drawing.hpp"
#include "GameApi.hpp"

#include <QTimer>

class GameWidget : public Drawing {
  Q_OBJECT

public:
  enum class Mode { StartScreen, Playing, GameOver };

  GameWidget(QMainWindow* parent, GameApiQt api, int tickMs = 30);

protected:
  void paintEvent(QPaintEvent* e) override;
  void keyPressEvent(QKeyEvent* e) override;

private:
  void onTick();
  UserAction_t mapKey(QKeyEvent* e) const;

private:
  GameApiQt api_;
  QTimer* timer_{nullptr};

  Mode mode_{Mode::StartScreen};
  GameInfo_t last_{};

  UserAction_t prev_{None};
};
