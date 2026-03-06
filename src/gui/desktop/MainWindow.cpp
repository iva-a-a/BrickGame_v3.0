#include "MainWindow.hpp"

#include <QHBoxLayout>
#include <QPushButton>
#include <QWidget>
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

  current_ = new GameWidget(this, 30);
  current_->setWindowTitle("Brick Game");
  current_->show();
  hide();
}

void MainWindow::onTetris() {
  deleteGame();

  current_ = new GameWidget(this, 16);
  current_->setWindowTitle("Brick Game");
  current_->show();
  hide();
}
