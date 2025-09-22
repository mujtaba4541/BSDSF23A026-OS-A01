# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -I./include
AR = ar
RANLIB = ranlib

# Directories
SRCDIR = src
OBJDIR = obj
BINDIR = bin
LIBDIR = lib
INCDIR = include

# Library and targets
LIBNAME = mputils
STATIC_LIB = $(LIBDIR)/lib$(LIBNAME).a
TARGET_STATIC = $(BINDIR)/client_static

# Source files
SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
LIB_OBJS = $(filter-out $(OBJDIR)/main.o, $(OBJS))

# Default target
all: static

# Static library target
static: $(TARGET_STATIC)

# Create static library
$(STATIC_LIB): $(LIB_OBJS) | $(LIBDIR)
	$(AR) rcs $@ $(LIB_OBJS)
	$(RANLIB) $@

# Link static executable
$(TARGET_STATIC): $(OBJDIR)/main.o $(STATIC_LIB) | $(BINDIR)
	$(CC) $(OBJDIR)/main.o -L$(LIBDIR) -l$(LIBNAME) -o $@

# Compile source files to object files
$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create directories
$(BINDIR) $(LIBDIR) $(OBJDIR):
	mkdir -p $@

# Clean build artifacts
clean:
	rm -rf $(OBJDIR) $(BINDIR) $(LIBDIR)

# Install (for later parts)
install:
	@echo "Install target will be implemented in later features"

# Run static version
run-static: $(TARGET_STATIC)
	./$(TARGET_STATIC)

# Analyze library
analyze: $(STATIC_LIB)
	@echo "=== Library contents ==="
	ar -t $(STATIC_LIB)
	@echo "=== Symbols in library ==="
	nm $(STATIC_LIB)

.PHONY: all static clean install run-static analyze
