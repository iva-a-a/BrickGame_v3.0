CPP = g++
C = gcc -std=c11
CFLAGS = -Wall -Werror -Wextra
CPPFLAGS += $(CFLAGS) -std=c++17

OS := $(shell uname)
ifeq ($(OS),Darwin)

GTEST_PREFIX := $(shell brew --prefix googletest)
TEST_INCLUDES = -I$(GTEST_PREFIX)/include -DUNIT_TESTS
TEST_LIBS = -L$(GTEST_PREFIX)/lib -lgtest -lgtest_main -pthread
endif
ifeq ($(OS),Linux)
TEST_INCLUDES = -DUNIT_TESTS
TEST_LIBS = -lgtest -lsubunit -pthread
endif

LDLIBS = -fprofile-arcs -ftest-coverage

LIBDIR_TET = brick_game/tetris
LIBDIR_SN = brick_game/snake

GUIDIR_TET = gui/cli/cli_tetris
GUIDIR_SN = gui/cli/cli_snake
GUIDIR = gui/cli

BINDIR = ./bin

LIBRARY_TET = tetris.a
LIBRARY_SN = snake.a

SOURCES_C = $(wildcard $(LIBDIR_TET)/*.c) $(wildcard $(GUIDIR_TET)/*.c) $(wildcard $(GUIDIR)/*.c)
SOURCES_CPP = $(wildcard $(LIBDIR_SN)/*.cpp) $(wildcard $(GUIDIR_SN)/*.cpp) $(wildcard $(GUIDIR)/*.cpp)
SOURCES_TEST = $(wildcard ./tests/*.cpp)

OBJECTS_C = $(SOURCES_C:.c=.o)
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)
OBJECTS_TEST = $(SOURCES_TEST:.cpp=.o)

GAME_CONSOLE = console
GAME_DESKTOP = desktop
GAME = brickgame
GAME_VERSION = 2.0

ALL_SRC = $(wildcard */*.h */*/*.h */*/*/*.h */*.c */*/*.c */*/*/*.c */*.cpp */*/*.cpp */*/*/*.cpp)

.PHONY: all install uninstall clean dvi dist $(GAME_CONSOLE) $(GAME_DESKTOP) test

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

test: clean $(LIBRARY_SN) $(OBJECTS_TEST)
	$(CPP) $(CPPFLAGS) $(OBJECTS_TEST) -o test -L. $(LIBRARY_SN) $(TEST_LIBS)
	rm -f $(OBJECTS_TEST)
	./test

gcov_report: CPPFLAGS += $(LDLIBS)
gcov_report: clean $(LIBRARY_SN)
	$(CPP) $(CPPFLAGS) -o gcov_r $(SOURCES_TEST) -L. -l$(LIBRARY_SN) $(TEST_LIBS)
	mkdir coverage_report
	./gcov_r
	python3 -m gcovr -r . --html --html-details -o coverage_report/index.html --exclude test
	@xdg-open coverage_report/index.html || open coverage_report/index.html || echo "Please open coverage_report/index.html manually."

install: clean $(GAME_CONSOLE) $(GAME_DESKTOP)
	mkdir $(BINDIR)
	cp build_desk/$(GAME_DESKTOP) $(BINDIR)
	cp build_cli/$(GAME_CONSOLE) $(BINDIR)
	@clear
	@echo Install in "bin".

uninstall:
	rm -rf $(BINDIR)
	@clear
	@echo Uninstall completed.

dvi:
	doxygen
	@clear
	@open doxygen/html/index.html || xdg-open doxygen/html/index.html

dist:
	mkdir $(GAME)-$(GAME_VERSION)
	cp -r brick_game gui Makefile $(GAME)-$(GAME_VERSION)
	tar -czf $(GAME)-$(GAME_VERSION).tar.gz $(GAME)-$(GAME_VERSION)
	rm -rf $(GAME)-$(GAME_VERSION)

clean:
	rm -f $(GAME) $(LIBDIR_TET)/*.o $(GUIDIR_TET)/*.o $(GUIDIR)/*.o $(LIBDIR_SN)/*.o $(GUIDIR_SN)/*.o ./tests/*.o
	rm -f *.a test gcov_r
	rm -f *.txt *.gz
	rm -f gcov* coverage.info *.gcov */*.gcov */*.gcda */*.gcno */*/*.gcov */*/*.gcda */*/*.gcno
	rm -rf doxygen desk build_cli build_desk coverage_report
	@clear
	@echo Clean completed.

%.o: %.c
	$(C) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CPP) $(CPPFLAGS) $(TEST_INCLUDES) -c -o $@ $<

$(LIBRARY_TET): $(LIBDIR_TET)/back_tetris.o
	ar rcs $@ $^
	ranlib $@

$(LIBRARY_SN): $(LIBDIR_SN)/controller_snake.o $(LIBDIR_SN)/model_snake.o
	ar rcs $@ $^
	ranlib $@

clang:
	cp ./../materials/linters/.clang-format ./
	clang-format -i $(ALL_SRC)
	rm -f .clang-format

valgrind:
	valgrind --tool=memcheck --leak-check=yes ./test