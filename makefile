CXX = clang++

SRC_PATH = src
BUILD_PATH = build
BIN_PATH = $(BUILD_PATH)/bin

BIN_NAME = main

SRC_EXT = cpp

SOURCES = $(shell find $(SRC_PATH) -type f -name '*.$(SRC_EXT)')
OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(BUILD_PATH)/%.o)
DEPS    = $(OBJECTS:.o=.d)

CXXFLAGS = -std=c++23 -Wall -Wextra -g
INCLUDES = -I $(SRC_PATH)/

#.PHONY: dirs
#dirs:
#	@echo "Creating directories"
#	@mkdir -p $(dir $(OBJECTS))
#	@mkdir -p $(BIN_PATH)

.PHONY: clean
clean:
	@echo "Deleting $(BIN_NAME) symlink"
	@$(RM) $(BIN_NAME)
	@echo "Deleting directories"
	@$(RM) -r $(BIN_PATH)/$(BIN_NAME)
	@$(RM) -r $(OBJECTS)
	@$(RM) -r $(DEPS)

# checks the executable and symlinks to the output
.PHONY: all
all: $(BIN_PATH)/$(BIN_NAME)
	@echo "Making symlink: $(BIN_NAME) -> $<"
	@$(RM) $(BIN_NAME)
	@ln -s $(BIN_PATH)/$(BIN_NAME) $(BIN_NAME)

# Creation of the executable
$(BIN_PATH)/$(BIN_NAME): $(OBJECTS)
	@echo "Linking: $@"
	$(CXX) $(OBJECTS) -o $@

# Add dependency files, if they exist
-include $(DEPS)

# Source file rules
# After the first compilation they will be joined with the rules from the
# dependency files to provide header dependencies
$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo "Compiling: $< -> $@"
	$(CXX) $(CXXFLAGS) $(COMPILE_FLAGS) $(INCLUDES) -MP -MMD -c $< -o $@