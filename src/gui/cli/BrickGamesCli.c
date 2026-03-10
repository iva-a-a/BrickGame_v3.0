#include "display.h"
#include "render.h"
#include "render_logic.h"

int main() {
  setup_gui();

  AvailableGames_t games = listAvailableGames();
  if (games.count <= 0 || games.items == NULL) {
    delete_gui();
    return 1;
  }

  int key;
  while ((key = getch()) != 27) {
    print_game_selection(games);
    if (key >= '1' && key <= '9') {
      int idx = key - '1';
      if (idx < games.count) {
        if (selectGameById(games.items[idx].id)) {
          print_game();
          clear_screen();
        }
      }
    }
  }

  freeAvailableGames(games);
  delete_gui();
  return 0;
}
