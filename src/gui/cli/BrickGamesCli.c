#include "display.h"
#include "render.h"
#include "render_logic.h"


// при нажатии на кнопки выбора игры, должен отправляться запрос на выбор


int main() {
  setup_gui();
  int key = getch();

  while (key != 27) {
    print_game_selection();
    if (key == 't' || key == 'T') {
      print_game();
      clear_screen();
    } else if (key == 's' || key == 'S') {
      print_game();
      clear_screen();
    }
    key = getch();
  }
  delete_gui();
  return 0;
}
