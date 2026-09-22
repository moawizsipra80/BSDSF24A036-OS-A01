CC = gcc
CFLAGS = -Wall -g -fPIC
INCLUDE = -I./include

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib

TARGET = $(BIN_DIR)/client_dynamic
LIBRARY = $(LIB_DIR)/libmyutils.so

LIB_OBJS = $(OBJ_DIR)/mystfunctions.o $(OBJ_DIR)/myfilefunctions.o
MAIN_OBJ = $(OBJ_DIR)/main.o

all: $(TARGET)

# Create dynamic library
$(LIBRARY): $(LIB_OBJS)
	$(CC) -shared -o $(LIBRARY) $(LIB_OBJS)

# Link main with dynamic library
$(TARGET): $(MAIN_OBJ) $(LIBRARY)
	$(CC) $(CFLAGS) -o $(TARGET) $(MAIN_OBJ) -L$(LIB_DIR) -lmyutils

# Compile main.c
$(MAIN_OBJ): $(SRC_DIR)/main.c include/mystfunctions.h include/myfilefunctions.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $(SRC_DIR)/main.c -o $(MAIN_OBJ)

# Compile library source files with -fPIC
$(OBJ_DIR)/mystfunctions.o: $(SRC_DIR)/mystfunctions.c include/mystfunctions.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $(SRC_DIR)/mystfunctions.c -o $(OBJ_DIR)/mystfunctions.o

$(OBJ_DIR)/myfilefunctions.o: $(SRC_DIR)/myfilefunctions.c include/myfilefunctions.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $(SRC_DIR)/myfilefunctions.c -o $(OBJ_DIR)/myfilefunctions.o

.PHONY: all clean run

clean:
	rm -f $(OBJ_DIR)/*.o
	rm -f $(BIN_DIR)/client_dynamic
	rm -f $(LIBRARY)

run: all
	LD_LIBRARY_PATH=$(LIB_DIR) ./$(TARGET)