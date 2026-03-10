#pragma once

#include <QMainWindow>

class GameWidget;
class QVBoxLayout;

class MainWindow : public QMainWindow {
  Q_OBJECT
public:
  MainWindow();
  ~MainWindow() override = default;

private:
  void setupUi();
  void loadGames();
  void openSelectedGame();
  void deleteGame();

private:
  GameWidget *current_{nullptr};
  QVBoxLayout *layout_{nullptr};
};
