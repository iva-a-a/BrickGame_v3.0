#include "display.h"
#include "render_logic.h"
#include "render.h"


int main() {
  setup_gui();
  int key = getch();

  while (key != 27) {
    print_game_setection();
    if (key == 't' || key == 'T') {
      print_tetris();
      clear_screen();
    } else if (key == 's' || key == 'S') {
      print_snake();
      clear_screen();
    }
    key = getch();
  }
  delete_gui();
  return 0;
}
