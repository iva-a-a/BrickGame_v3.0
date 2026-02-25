#include "MainWindow.hpp"

#include <QHBoxLayout>
#include <QPushButton>
#include <QWidget>

#include "../../brick_game/snake/wrapper/SnakeWrapper.h"
#include "../../brick_game/tetris/controller_tetris.h"
#include "GameWidget.hpp"

MainWindow::MainWindow() { setupUi(); }

void MainWindow::setupUi() {
  setFixedSize(300, 100);
  setWindowTitle("BRICK GAME V2.0");

  auto* central = new QWidget(this);
  setCentralWidget(central);

  auto* layout = new QHBoxLayout(central);

  auto* snakeBtn = new QPushButton("SNAKE", this);
  auto* tetrisBtn = new QPushButton("TETRIS", this);

  snakeBtn->setFixedSize(100, 50);
  tetrisBtn->setFixedSize(100, 50);

  connect(snakeBtn, &QPushButton::clicked, this, &MainWindow::onSnake);
  connect(tetrisBtn, &QPushButton::clicked, this, &MainWindow::onTetris);

  layout->addWidget(snakeBtn);
  layout->addWidget(tetrisBtn);
}

void MainWindow::deleteGame() {
  if (current_) {
    delete current_;
    current_ = nullptr;
  }
}

void MainWindow::onSnake() {
  deleteGame();

  GameApiQt api;
  api.update = [] { return snake_updateCurrentState(); };
  api.input = [](UserAction_t a, bool h) { snake_userInput(a, h); };
  api.drawNext = false;
  api.useHold = true;

  current_ = new GameWidget(this, api, 30);
  current_->setWindowTitle("Snake");
  current_->show();
  hide();
}

void MainWindow::onTetris() {
  deleteGame();

  GameApiQt api;
  api.update = [] { return tetris_updateCurrentState(); };
  api.input = [](UserAction_t a, bool h) { tetris_userInput(a, h); };
  api.drawNext = true;
  api.useHold = false;

  current_ = new GameWidget(this, api, 16);
  current_->setWindowTitle("Tetris");
  current_->show();
  hide();
}
