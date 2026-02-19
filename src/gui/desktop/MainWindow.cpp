#include "MainWindow.hpp"

// MainWindow::MainWindow() { setup_ui(); }

// void MainWindow::setup_ui() {
//   setFixedSize(300, 100);
//   QMainWindow::setWindowTitle("BRICK GAME V2.0");
//   QWidget *centralWidget = new QWidget(this);
//   setCentralWidget(centralWidget);

//   QHBoxLayout *mainLayout = new QHBoxLayout(centralWidget);

//   QPushButton *snakeButton = new QPushButton("SNAKE", this);
//   QPushButton *tetrisButton = new QPushButton("TETRIS", this);

//   snakeButton->setFixedSize(100, 50);
//   tetrisButton->setFixedSize(100, 50);

//   connect(snakeButton, &QPushButton::clicked, this,
//           &MainWindow::on_push_snake_clicked);
//   connect(tetrisButton, &QPushButton::clicked, this,
//           &MainWindow::on_push_tetris_clicked);

//   mainLayout->addWidget(snakeButton);
//   mainLayout->addWidget(tetrisButton);

//   mainLayout->setContentsMargins(0, 0, 0, 0);
//   mainLayout->setSpacing(10);
// }

// void MainWindow::on_push_snake_clicked() {
//   delete_game();
//   SnakeWidget *snake = new SnakeWidget(this);
//   snake->show();
//   this->hide();
// }

// void MainWindow::on_push_tetris_clicked() {
//   delete_game();
//   TetrisWidget *tetris = new TetrisWidget(this);
//   tetris->show();
//   this->hide();
// }

#include "MainWindow.hpp"
#include "GameWidget.hpp"

#include <QHBoxLayout>
#include <QPushButton>
#include <QWidget>

#include "../../brick_game/tetris/controller_tetris.h"
#include "../../brick_game/snake/wrapper/SnakeWrapper.h"

MainWindow::MainWindow() {
  setupUi();
}

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
  api.input  = [](UserAction_t a, bool h) { snake_userInput(a, h); };
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
  api.input  = [](UserAction_t a, bool h) { tetris_userInput(a, h); };
  api.drawNext = true;
  api.useHold = false;

  current_ = new GameWidget(this, api, 30);
  current_->setWindowTitle("Tetris");
  current_->show();
  hide();
}
