#include "display_snake.h"

SnakeDisplay::SnakeDisplay(Controller *c) : controller{c} {}

void SnakeDisplay::print_win() {
  mvprintw(9, 0, "%*c", 22, ' ');
  mvprintw(10, 0, "         YOU WIN        ");
  mvprintw(11, 0, "%*c", 22, ' ');
}

void SnakeDisplay::game_snake() {
  UserAction_t prev_key = None;

  while (true) {
    UserAction_t key = input_key();
    bool hold = (prev_key == key && key != None);
    prev_key = key;

    controller->userInput(key, hold);

    GameInfo_t info = controller->updateCurrentState();
    if (info.pause == 9) {
      controller->clearGameInfo(info);
      break;
    }

    printCurrentState(info);
    controller->clearGameInfo(info);
  }
}

void SnakeDisplay::printCurrentState(GameInfo_t &info) {
  if (info.pause == 2) {
    print_start();

  } else if (info.pause == 3) {
    print_game_over();

  } else {
    print_game_board();
    print_stats_ban();
    print_stats(info.level, info.speed, info.score, info.high_score, 500);
    print_arr(info.field);
    print_arr(info.next);

    if (info.pause == 1) {
      print_pause();
    } else if (info.pause == 4) {
      print_win();
    }
  }

  refresh();
}
