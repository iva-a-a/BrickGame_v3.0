#include "display.h"

void setup_gui() {
  initscr();
  curs_set(0);
  noecho();
  keypad(stdscr, TRUE);
  nodelay(stdscr, TRUE);
}

void delete_gui() { endwin(); }

UserAction_t input_key() {
  UserAction_t return_key;
  int key = getch();
  switch (key) {
    case KEY_DOWN:
      return_key = Down;
      break;
    case KEY_LEFT:
      return_key = Left;
      break;
    case KEY_RIGHT:
      return_key = Right;
      break;
    case 10:
      return_key = Start;
      break;
    case 'p':
    case 'P':
      return_key = Pause;
      break;
    case 27:
      return_key = Terminate;
      break;
    case 32:
      return_key = Action;
      break;
    case KEY_UP:
      return_key = Up;
      break;
    default:
      return_key = None;
      break;
  }
  return return_key;
}
