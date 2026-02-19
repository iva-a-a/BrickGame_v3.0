#pragma once

// #include <QMainWindow>
// #include <QPushButton>
// #include <QVBoxLayout>


// class MainWindow : public QMainWindow {
//   Q_OBJECT
//  public:
//   MainWindow();

//   ~MainWindow();

//  private:
//   void setup_ui();

//  private slots:
//   void on_push_snake_clicked();
//   void on_push_tetris_clicked();
// };

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
