CC = gcc
CFLAGS = -Wall -g
INCLUDE = -I./include

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib

TARGET = $(BIN_DIR)/client_static
LIBRARY = $(LIB_DIR)/libmyutils.a

LIB_OBJS = $(OBJ_DIR)/mystfunctions.o $(OBJ_DIR)/myfilefunctions.o
MAIN_OBJ = $(OBJ_DIR)/main.o

all: $(TARGET)

# Create static library
$(LIBRARY): $(LIB_OBJS)
	ar rcs $(LIBRARY) $(LIB_OBJS)

# Link main with static library
$(TARGET): $(MAIN_OBJ) $(LIBRARY)
	$(CC) $(CFLAGS) -o $(TARGET) $(MAIN_OBJ) -L$(LIB_DIR) -lmyutils

# Compile main.c
$(MAIN_OBJ): $(SRC_DIR)/main.c include/mystfunctions.h include/myfilefunctions.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $(SRC_DIR)/main.c -o $(MAIN_OBJ)

# Compile library source files
$(OBJ_DIR)/mystfunctions.o: $(SRC_DIR)/mystfunctions.c include/mystfunctions.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $(SRC_DIR)/mystfunctions.c -o $(OBJ_DIR)/mystfunctions.o

$(OBJ_DIR)/myfilefunctions.o: $(SRC_DIR)/myfilefunctions.c include/myfilefunctions.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $(SRC_DIR)/myfilefunctions.c -o $(OBJ_DIR)/myfilefunctions.o

.PHONY: all clean run

clean:
	rm -f $(OBJ_DIR)/*.o
	rm -f $(BIN_DIR)/client_static
	rm -f $(LIBRARY)

run: all
	./$(TARGET)