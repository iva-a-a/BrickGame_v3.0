CXX ?= g++
CC  ?= gcc
AR  ?= ar
RANLIB ?= ranlib

CSTD = -std=c11
CPPSTD = -std=c++17

WARN = -Wall -Wextra -Werror

CFLAGS   += $(WARN) $(CSTD)
CPPFLAGS += $(WARN) $(CPPSTD)

ROOT := $(shell pwd)

BRICK_DIR = brick_game
GUIDIR_CLI = gui/cli

TET_DIR = $(BRICK_DIR)/tetris
SNAKE_DIR = $(BRICK_DIR)/snake
API_DIR = $(BRICK_DIR)/api

BUILD_DIR = build
OBJ_DIR   = $(BUILD_DIR)/obj
LIB_DIR   = $(BUILD_DIR)/lib

BUILD_CLI  = build_cli
BUILD_DESK = build_desk

SWIFT ?= swift
SWIFT_BUILD_CONF ?= release
SWIFT_BUILD_DIR = $(BRICK_DIR)/.build/$(SWIFT_BUILD_CONF)

BRIDGE_LIB_NAME = ClientBridge
BRIDGE_DYLIB = $(SWIFT_BUILD_DIR)/lib$(BRIDGE_LIB_NAME).dylib
BRIDGE_RPATH = @executable_path/../build/lib

CFLAGS   += -I$(API_DIR)
CPPFLAGS += -I$(API_DIR)

TET_C   = $(wildcard $(TET_DIR)/*.c)
SNAKE_CPP = $(wildcard $(SNAKE_DIR)/*.cpp) $(wildcard $(SNAKE_DIR)/*/*.cpp)

UI_CLI_C   = $(wildcard $(GUIDIR_CLI)/*.c)

TET_OBJ   = $(patsubst $(ROOT)/%,%,$(addprefix $(OBJ_DIR)/,$(TET_C:.c=.o)))
SNAKE_OBJ = $(patsubst $(ROOT)/%,%,$(addprefix $(OBJ_DIR)/,$(SNAKE_CPP:.cpp=.o)))
UI_CLI_OBJ    = $(patsubst $(ROOT)/%,%,$(addprefix $(OBJ_DIR)/,$(UI_CLI_C:.c=.o)))

TET_LIB   = $(LIB_DIR)/libtetris.a
SNAKE_LIB = $(LIB_DIR)/libsnake.a

GAME_CONSOLE = console
GAME_DESKTOP = desktop

.PHONY: all clean swift_bridge $(GAME_CONSOLE) $(GAME_DESKTOP)

all: $(GAME_DESKTOP) $(GAME_CONSOLE)
	@echo "Built: $(BUILD_CLI) and $(BUILD_DESK)"

swift_bridge:
	cd $(BRICK_DIR) && $(SWIFT) build -c $(SWIFT_BUILD_CONF) --product $(BRIDGE_LIB_NAME)

$(GAME_CONSOLE): swift_bridge $(TET_LIB) $(SNAKE_LIB) $(UI_CLI_OBJ)
	mkdir -p $(BUILD_CLI) $(LIB_DIR)
	cp -f $(BRIDGE_DYLIB) $(LIB_DIR)/
	$(CXX) -o $(BUILD_CLI)/$@ $(UI_CLI_OBJ) \
		-L$(LIB_DIR) -l$(BRIDGE_LIB_NAME) \
		-Wl,-rpath,$(BRIDGE_RPATH) \
		-lncurses
	@clear
	@echo "Built in $(BUILD_CLI)"

# --- desktop  пока как есть
$(GAME_DESKTOP): $(TET_LIB) $(SNAKE_LIB)
	mkdir -p desk
	cd desk && qmake6 ../gui/desktop
	sed -i '' 's/-framework AGL//g' desk/Makefile
	sed -i '' 's/-framework OpenGL//g' desk/Makefile
	cd desk && make
	mkdir -p $(BUILD_DESK)
	mv desk/desktop ./$(BUILD_DESK)/
	rm -rf desk
	@echo "Built in $(BUILD_DESK)"

$(TET_LIB): $(TET_OBJ)
	mkdir -p $(LIB_DIR)
	$(AR) rcs $@ $^
	$(RANLIB) $@

$(SNAKE_LIB): $(SNAKE_OBJ)
	mkdir -p $(LIB_DIR)
	$(AR) rcs $@ $^
	$(RANLIB) $@

$(OBJ_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) -c -o $@ $<

clean:
	rm -rf $(BUILD_DIR) $(BUILD_CLI) $(BUILD_DESK) desk
	@clear
	@echo "Clean completed."
