CPP = g++
C = gcc -std=c11
CFLAGS = -Wall -Werror -Wextra
CPPFLAGS += $(CFLAGS) -std=c++17

LIBDIR_TET = brick_game/tetris
LIBDIR_SN = brick_game/snake

GUIDIR = gui/cli

LIBRARY_TET = libtetris.a
LIBRARY_SN = libsnake.a

SOURCES_C_LIB = $(wildcard $(LIBDIR_TET)/*.c)
SOURCES_CPP_LIB = $(wildcard $(LIBDIR_SN)/*.cpp) $(wildcard $(LIBDIR_SN)/*/*.cpp)

OBJECTS_C_LIB = $(SOURCES_C_LIB:.c=.o)
OBJECTS_CPP_LIB = $(SOURCES_CPP_LIB:.cpp=.o)

SOURCES_UI = $(wildcard $(GUIDIR)/*.c)
OBJECTS_UI = $(SOURCES_UI:.c=.o)

GAME_CONSOLE = console
GAME_DESKTOP = desktop

.PHONY: all clean $(GAME_CONSOLE) $(GAME_DESKTOP)

all: $(GAME_DESKTOP) $(GAME_CONSOLE)
	@clear
	@echo Build in "build_cli" and "build_desk".

$(GAME_CONSOLE): $(OBJECTS_UI) $(LIBRARY_TET) $(LIBRARY_SN)
	mkdir -p build_cli
	$(CPP) $(CPPFLAGS) -o $@ $^ -lncurses
	mv console ./build_cli
	@clear
	@echo Build in "build_cli".

$(GAME_DESKTOP): $(LIBRARY_TET) $(LIBRARY_SN)
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
	find . -type f -name "*.o" -delete
	rm -f *.a
	rm -f *.txt
	rm -rf desk build_cli build_desk
	@clear
	@echo Clean completed.

%.o: %.c
	$(C) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CPP) $(CPPFLAGS) -c -o $@ $<

$(LIBRARY_TET): $(OBJECTS_C_LIB)
	ar rcs $@ $^
	ranlib $@

$(LIBRARY_SN): $(OBJECTS_CPP_LIB)
	ar rcs $@ $^
	ranlib $@
