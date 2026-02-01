CC = gcc

SRC_DIR = src
BUILD_DIR = build
RAYLIB_PATH = C:\raylib\raylib

LIBS = -lraylib -lopengl32 -lgdi32 -lwinmm # Windows_NT
LIB_PATH = -L. -L$(RAYLIB_PATH)/src
INCLUDE_PATH = -I. -I$(RAYLIB_PATH)/src -I$(RAYLIB_PATH)/src/external
CFLAGS = -Wall -std=c99

SRCS = src/main.c
OBJS = build/main.o

TARGET = mandelbrot

.PHONY: all clean

all: $(BUILD_DIR) $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(BUILD_DIR)/$@ $(CFLAGS) $(INCLUDE_PATH) $(LIB_PATH) $(LIBS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) -c $< -o $@ $(CFLAGS) $(INCLUDE_PATH)

clean:
	rm -rf $(BUILD_DIR)