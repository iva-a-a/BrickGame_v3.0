#include "MainWindow.hpp"

#include <QPushButton>
#include <QVBoxLayout>
#include <QWidget>

#include "GameWidget.hpp"
#include "apiBG.h"

MainWindow::MainWindow() {
  setupUi();
  loadGames();
}

void MainWindow::setupUi() {
  setFixedSize(250, 300);
  setWindowTitle("BRICK GAME V3.0");

  auto *central = new QWidget(this);
  setCentralWidget(central);

  layout_ = new QVBoxLayout(central);
  layout_->setSpacing(12);
  layout_->setContentsMargins(20, 20, 20, 20);
}

void MainWindow::loadGames() {
  AvailableGames_t games = listAvailableGames();

  for (int i = 0; i < games.count; ++i) {
    const GameListItem_t &game = games.items[i];

    auto *button = new QPushButton(QString::fromUtf8(game.name), this);
    button->setFixedSize(200, 60);

    connect(button, &QPushButton::clicked, this, [this, gameId = game.id]() {
      if (selectGameById(gameId)) {
        openSelectedGame();
      }
    });

    layout_->addWidget(button);
  }

  freeAvailableGames(games);
  adjustSize();
  setFixedSize(sizeHint());
}

void MainWindow::deleteGame() {
  if (current_) {
    delete current_;
    current_ = nullptr;
  }
}

void MainWindow::openSelectedGame() {
  deleteGame();

  current_ = new GameWidget(this);
  current_->setWindowTitle("Brick Game");
  current_->show();
  hide();
}
