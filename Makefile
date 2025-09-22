# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -I./include

# Directories
SRCDIR = src
OBJDIR = obj
BINDIR = bin
INCDIR = include

# Targets
TARGET = $(BINDIR)/client
SOURCES = $(wildcard $(SRCDIR)/*.c)
OBJECTS = $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

# Default target
all: $(TARGET)

# Link the executable
$(TARGET): $(OBJECTS) | $(BINDIR)
	$(CC) $(OBJECTS) -o $@

# Compile source files to object files
$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create directories if they don't exist
$(BINDIR):
	mkdir -p $(BINDIR)

$(OBJDIR):
	mkdir -p $(OBJDIR)

# Clean build artifacts
clean:
	rm -rf $(OBJDIR) $(BINDIR)

# Install (for later parts)
install:
	@echo "Install target will be implemented in later features"

# Run the program
run: $(TARGET)
	./$(TARGET)

.PHONY: all clean install run
