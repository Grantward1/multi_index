CFLAGS := -Wall -Wextra

MKDIR := mkdir -p
RM := $(RM) -r

INC_DIR := inc
SRC_DIR := src
TST_DIR := test
BLD_DIR := build
BIN_DIR := bin

INC_FLAGS := $(addprefix -I, $(INC_DIR))

LIB_SRC_FILE := $(shell find $(SRC_DIR)/*.c)
TST_SRC_FILE := $(shell find $(TST_DIR)/*.c)

LIB_OBJ_FILE := $(patsubst $(SRC_DIR)/%.c,$(BLD_DIR)/%.o,$(LIB_SRC_FILE))
TST_OBJ_FILE := $(patsubst $(TST_DIR)/%.c,$(BLD_DIR)/test/%.o,$(TST_SRC_FILE))

TST_BIN_FILE := $(patsubst $(TST_DIR)/%.c,$(BIN_DIR)/test/%,$(TST_SRC_FILE))


.PHONY: dirs test all debug profile clean print

print-%  : ; @echo $* = $($*)

dirs:
	$(MKDIR) $(BLD_DIR)
	$(MKDIR) $(BLD_DIR)/test
	$(MKDIR) $(BIN_DIR)
	$(MKDIR) $(BIN_DIR)/test

test: dirs
test: $(TST_BIN_FILE)

all: test

debug: $(CFLAGS) += -g
debug: all

profile: $(CFLAGS) += -pg
profile: debug

clean:
	$(RM) $(BLD_DIR)
	$(RM) $(BIN_DIR)


$(LIB_OBJ_FILE):
	$(CC) $(CFLAGS) $(INC_FLAGS) -c -o $@ $(patsubst $(BLD_DIR)/%.o,$(SRC_DIR)/%.c,$@)
$(TST_OBJ_FILE):
	$(CC) $(CFLAGS) $(INC_FLAGS) -c -o $@ $(patsubst $(BLD_DIR)/test/%.o,$(TST_DIR)/%.c,$@)
$(TST_BIN_FILE): $(TST_OBJ_FILE) $(LIB_OBJ_FILE)
	$(CC) $(CFLAGS) $(INC_FLAGS) -o $@ $^
