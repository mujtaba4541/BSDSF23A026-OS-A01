# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -I./include -fPIC
AR = ar
RANLIB = ranlib

# Directories
SRCDIR = src
OBJDIR = obj
BINDIR = bin
LIBDIR = lib
INCDIR = include

# Library names
LIBNAME = mputils
STATIC_LIB = $(LIBDIR)/lib$(LIBNAME).a
DYNAMIC_LIB = $(LIBDIR)/lib$(LIBNAME).so

# Targets
TARGET_STATIC = $(BINDIR)/client_static
TARGET_DYNAMIC = $(BINDIR)/client_dynamic

# Source files
SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
LIB_OBJS = $(filter-out $(OBJDIR)/main.o, $(OBJS))

# Default target
all: static dynamic

# Static targets
static: $(TARGET_STATIC)

$(STATIC_LIB): $(LIB_OBJS) | $(LIBDIR)
	$(AR) rcs $@ $(LIB_OBJS)
	$(RANLIB) $@

$(TARGET_STATIC): $(OBJDIR)/main.o $(STATIC_LIB) | $(BINDIR)
	$(CC) $(OBJDIR)/main.o -L$(LIBDIR) -l$(LIBNAME) -o $@

# Dynamic targets
dynamic: $(TARGET_DYNAMIC)

$(DYNAMIC_LIB): $(LIB_OBJS) | $(LIBDIR)
	$(CC) -shared $(LIB_OBJS) -o $@

$(TARGET_DYNAMIC): $(OBJDIR)/main.o | $(BINDIR)
	$(CC) $(OBJDIR)/main.o -L$(LIBDIR) -l$(LIBNAME) -o $@

# Compile source files to object files (with PIC for dynamic lib)
$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create directories
$(BINDIR) $(LIBDIR) $(OBJDIR):
	mkdir -p $@

# Clean build artifacts
clean:
	rm -rf $(OBJDIR) $(BINDIR) $(LIBDIR)

# Run static version
run-static: $(TARGET_STATIC)
	./$(TARGET_STATIC)

# Run dynamic version (with library path)
run-dynamic: $(TARGET_DYNAMIC)
	LD_LIBRARY_PATH=$(LIBDIR):$(LD_LIBRARY_PATH) ./$(TARGET_DYNAMIC)

# Analyze both versions
analyze: $(STATIC_LIB) $(DYNAMIC_LIB)
	@echo "=== Static Library Contents ==="
	ar -t $(STATIC_LIB)
	@echo "\n=== Dynamic Library Analysis ==="
	readelf -d $(DYNAMIC_LIB)
	@echo "\n=== File Sizes ==="
	ls -lh $(BINDIR)/
	@echo "\n=== Dynamic Executable Dependencies ==="
	ldd $(TARGET_DYNAMIC)

# Set library path for testing
set-path:
	export LD_LIBRARY_PATH=$(CURDIR)/$(LIBDIR):$$LD_LIBRARY_PATH
	@echo "LD_LIBRARY_PATH set to: $$LD_LIBRARY_PATH"

.PHONY: all static dynamic clean run-static run-dynamic analyze set-path
