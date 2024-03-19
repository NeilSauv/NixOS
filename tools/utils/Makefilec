CC = gcc
CFLAGS = -g -Wall -Wextra -Wvla -Werror -pedantic -std=c99 
ASAN_FLAGS = -fsanitize=address
CRITERION_FLAGS = -lcriterion
OBJ = $(wildcard *.o)
SRC = $(wildcard *.c)
BIN = out

all: $(OBJ)
	$(CC) $(CFLAGS) $(ASAN_FLAGS) $(SRC) -o $(BIN)
	./$(BIN) $(ARG)
	rm $(BIN)

test: $(OBJ)
	$(CC) $(CFLAGS) $(ASAN_FLAGS) $(CRITERION_FLAGS) $(SRC) -o $(BIN)
	./$(BIN) $(ARG)
	rm $(BIN)

no-asan: $(OBJ)
	$(CC) $(CFLAGS) $(SRC) -o $(BIN)
	./$(BIN) $(ARG)
	rm $(BIN)

build: $(OBJ)
	$(CC) $(CFLAGS) $(ASAN_FLAGS) $(SRC) -o $(BIN)

run: $(OBJ)
	$(CC) $(CFLAGS) $(ASAN_FLAGS) $(SRC) -o $(BIN)
	./$(BIN) $(ARG)

gdb: $(OBJ)
	$(CC) $(CFLAGS) $(SRC) -o $(BIN)
	gdb -tui $(BIN) -q
	rm $(BIN)

val: $(OBJ)
	$(CC) $(CFLAGS) $(SRC) -o $(BIN)
	valgrind --tool=memcheck --leak-check=yes --show-reachable=yes -s ./$(BIN) $(ARG)
	rm $(BIN)

clean:
	rm -rf $(BIN)
