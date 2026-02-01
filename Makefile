CC = gcc

SRC_DIR = src
BUILD_DIR = build
#RAYLIB_PATH = C:\raylib\raylib
RAYLIB_PATH = /usr/local/Cellar/raylib/5.5

ifeq ($(OS), Windows_NT)
    detected_OS := Windows
else
    # Check for Unix-like systems using uname
    detected_OS := $(shell uname -s)
    # Convert to lowercase and normalize
    detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
    detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
    detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
    detected_OS := $(shell echo $(detected_OS) | tr A-Z a-z)
endif

ifeq ($(detected_OS),windows)
	LIBS = -lraylib -lopengl32 -lgdi32 -lwinmm # Windows_NT
	LIB_PATH = -L. -L$(RAYLIB_PATH)/src
	INCLUDE_PATH = -I. -I$(RAYLIB_PATH)/src -I$(RAYLIB_PATH)/src/external
else ifeq ($(detected_OS),linux)
    # Linux-specific commands/variables
    #EXECUTABLE := 
    #PLATFORM_FLAGS := 
else ifeq ($(detected_OS),darwin)
    # macOS-specific commands/variables
    LIBS = -lraylib -framework OpenGL -framework Cocoa -framework IOKit -framework CoreAudio -framework CoreVideo
	LIB_PATH = -L. -L$(RAYLIB_PATH)/lib
	INCLUDE_PATH = -I. -I$(RAYLIB_PATH)/include        
endif

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
