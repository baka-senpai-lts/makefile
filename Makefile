BIN_DIR := bin
SRC_DIR := src
OBJ_DIR_LINUX := obj
OBJ_DIR_WIN := obj-win

BIN_NAME := $(BIN_DIR)/$(shell basename $(shell pwd))

BIN_LINUX := $(BIN_NAME)
BIN_WIN := $(BIN_NAME).exe

SRC := $(shell find $(SRC_DIR) -name *.cpp)

OBJ_LINUX := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR_LINUX)/%.o, $(SRC))
OBJ_WIN := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR_WIN)/%.o, $(SRC))

# Universal flags here
CC_FLAGS := -O3 -Os
LD_FLAGS :=

# Flags for Linux
CC_FLAGS_LINUX :=
CC_FLAGS_WIN :=

# Flags for Windows
LD_FLAGS_LINUX :=
LD_FLAGS_WIN := -static -static-libgcc -static-libstdc++

# Compilers
CC_LINUX := g++
CC_WIN := /usr/bin/i686-w64-mingw32-g++

# Set default goal (all linux windows run-linux run-windows)
.DEFAULT_GOAL := all

# Set default make flags
MAKEFLAGS += --jobs=4

$(BIN_LINUX): $(OBJ_LINUX)
	@mkdir -p $(BIN_DIR)
	$(CC_LINUX) $(LD_FLAGS) $(LD_FLAGS_LINUX) $(OBJ_LINUX) -o $@

$(OBJ_DIR_LINUX)/%.o: $(SRC_DIR)/%.cpp
	@echo $<
	@mkdir -p $(OBJ_DIR_LINUX)
	$(CC_LINUX) $(CC_FLAGS) $(CC_FLAGS_LINUX) -c $< -o $@

$(BIN_WIN): $(OBJ_WIN)
	@mkdir -p $(BIN_DIR)
	$(CC_WIN) $(LD_FLAGS) $(LD_FLAGS_WIN) $(OBJ_WIN) -o $@

$(OBJ_DIR_WIN)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR_WIN)
	$(CC_WIN) $(CC_FLAGS) $(CC_FLAGS_WIN) -c $< -o $@

.PHONY: clean all run run-linux run-windows linux windows

all: linux windows

linux: $(BIN_LINUX)

windows: $(BIN_WIN)

run: run-linux

run-linux: linux
	@$(BIN_LINUX)

run-windows: windows
	@wine $(BIN_WIN)

clean:
	@rm -Rf $(BIN_DIR) $(OBJ_DIR_LINUX) $(OBJ_DIR_WIN)
