#pragma once

#include <QMainWindow>

class GameWidget;

class MainWindow : public QMainWindow {
  Q_OBJECT
public:
  MainWindow();
  ~MainWindow() override = default;

private slots:
  void onSnake();
  void onTetris();

private:
  void setupUi();
  void deleteGame();

private:
  GameWidget* current_{nullptr};
};
