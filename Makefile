CUR_DIR := .
BIN_DIR := $(CUR_DIR)/bin
OBJ_DIR := $(CUR_DIR)/obj
INC_DIR := $(CUR_DIR)/inc
SRC_DIR := $(CUR_DIR)/src
LIB_DIR := $(CUR_DIR)/lib

LIB_STATIC_DIR := $(LIB_DIR)/static
LIB_SHARED_DIR := $(LIB_DIR)/shared

# pointer and take all header files
C_FLAGS := -I $(INC_DIR)

# the dynamics linker need to known the runtime
LDFLAGS := -Wl,-rpath,$(LIB_SHARED_DIR)

# Creates shared object files
create_objs:
	gcc -c -fPIC $(SRC_DIR)/HelloHoang.c -o $(OBJ_DIR)/HelloHoang.o $(C_FLAGS)
	gcc -c -fPIC $(SRC_DIR)/HelloWorld.c -o $(OBJ_DIR)/HelloWorld.o $(C_FLAGS)
	gcc -c -fPIC $(SRC_DIR)/main.c -o $(OBJ_DIR)/main.o $(C_FLAGS)

# Creates shared library
create_shared_lib: create_objs
	gcc -shared $(OBJ_DIR)/HelloHoang.o $(OBJ_DIR)/HelloWorld.o -o $(LIB_SHARED_DIR)/libHello.so

# Creates shared library
create_static_lib: create_objs
	ar rcs $(LIB_STATIC_DIR)/libHello.a $(OBJ_DIR)/HelloHoang.o $(OBJ_DIR)/HelloWorld.o

# Builds and Link dynamically with the shared library
shared_all: create_shared_lib
	gcc $(OBJ_DIR)/main.o -L$(LIB_SHARED_DIR) -lHello $(LDFLAGS) -o $(BIN_DIR)/shared/use-shared-library

# Builds and Link dynamically with the static library
static_all: create_static_lib
	gcc $(OBJ_DIR)/main.o  -L$(LIB_STATIC_DIR) -lHello -o $(BIN_DIR)/static/use-shared-library

# Removes compiled files
clean:
	rm -rf $(OBJ_DIR)/*.o 
	rm -rf $(LIB_SHARED_DIR)/*.so 
	rm -rf $(LIB_STATIC_DIR)/*.a 
	rm -rf $(BIN_DIR)/static/use-shared-library
	rm -rf $(BIN_DIR)/shared/use-shared-library