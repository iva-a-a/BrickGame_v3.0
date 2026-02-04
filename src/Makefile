CPP = g++
C = gcc -std=c11
CFLAGS = -Wall -Werror -Wextra
CPPFLAGS += $(CFLAGS) -std=c++17

LIBDIR_TET = brick_game/tetris
LIBDIR_SN = brick_game/snake

GUIDIR_TET = gui/cli/cli_tetris
GUIDIR_SN = gui/cli/cli_snake
GUIDIR = gui/cli

LIBRARY_TET = tetris.a
LIBRARY_SN = snake.a

SOURCES_C = $(wildcard $(LIBDIR_TET)/*.c) $(wildcard $(GUIDIR_TET)/*.c) $(wildcard $(GUIDIR)/*.c)
SOURCES_CPP = $(wildcard $(LIBDIR_SN)/*.cpp) $(wildcard $(GUIDIR_SN)/*.cpp) $(wildcard $(GUIDIR)/*.cpp)

OBJECTS_C = $(SOURCES_C:.c=.o)
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)

GAME_CONSOLE = console
GAME_DESKTOP = desktop
GAME = brickgame
GAME_VERSION = 2.0

ALL_SRC = $(wildcard */*.h */*/*.h */*/*/*.h */*.c */*/*.c */*/*/*.c */*.cpp */*/*.cpp */*/*/*.cpp)

.PHONY: all clean $(GAME_CONSOLE) $(GAME_DESKTOP)

all: $(GAME_DESKTOP) $(GAME_CONSOLE)
	@clear
	@echo Build in "build_cli" and "build_desk".

$(GAME_CONSOLE): $(OBJECTS_C) $(OBJECTS_CPP) $(LIBRARY_TET) $(LIBRARY_SN)
	mkdir -p build_cli
	$(CPP) $(CFLAGS) -o $@ $^ -lncurses
	mv console ./build_cli
	@clear
	@echo Build in "build_cli".

$(GAME_DESKTOP): clean
	mkdir desk
	cd desk && qmake6 ../gui/desktop
	sed -i '' 's/-framework AGL//g' desk/Makefile
	sed -i '' 's/-framework OpenGL//g' desk/Makefile
	cd desk && make
	mkdir -p build_desk
	mv desk/desktop ./build_desk
	rm -rf desk
	@clear
	@echo Build in "build_desk".

clean:
	rm -f $(GAME) $(LIBDIR_TET)/*.o $(GUIDIR_TET)/*.o $(GUIDIR)/*.o $(LIBDIR_SN)/*.o $(GUIDIR_SN)/*.o
	rm -f *.a
	rm -f *.txt
	rm -rf desk build_cli build_desk
	@clear
	@echo Clean completed.

%.o: %.c
	$(C) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CPP) $(CPPFLAGS) -c -o $@ $<

$(LIBRARY_TET): $(LIBDIR_TET)/back_tetris.o
	ar rcs $@ $^
	ranlib $@

$(LIBRARY_SN): $(LIBDIR_SN)/controller_snake.o $(LIBDIR_SN)/model_snake.o
	ar rcs $@ $^
	ranlib $@
