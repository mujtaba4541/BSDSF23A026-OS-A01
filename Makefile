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
MANDIR = man/man3

# Installation paths
PREFIX = /usr/local
INSTALL_BIN = $(PREFIX)/bin
INSTALL_LIB = $(PREFIX)/lib
INSTALL_INC = $(PREFIX)/include
INSTALL_MAN = $(PREFIX)/share/man/man3

# Library names
LIBNAME = mputils
STATIC_LIB = $(LIBDIR)/lib$(LIBNAME).a
DYNAMIC_LIB = $(LIBDIR)/lib$(LIBNAME).so

# Targets
TARGET_STATIC = $(BINDIR)/client_static
TARGET_DYNAMIC = $(BINDIR)/client_dynamic
TARGET = $(TARGET_DYNAMIC)  # Default target

# Source files
SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
LIB_OBJS = $(filter-out $(OBJDIR)/main.o, $(OBJS))

# Default target
all: $(TARGET)

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

$(TARGET_DYNAMIC): $(OBJDIR)/main.o $(DYNAMIC_LIB) | $(BINDIR)
	$(CC) $(OBJDIR)/main.o -L$(LIBDIR) -l$(LIBNAME) -o $@

# Compile source files to object files
$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create directories
$(BINDIR) $(LIBDIR) $(OBJDIR):
	mkdir -p $@

# Installation
install: all
	# Install binaries
	install -d $(DESTDIR)$(INSTALL_BIN)
	install -m 755 $(TARGET_DYNAMIC) $(DESTDIR)$(INSTALL_BIN)/client
	# Install libraries
	install -d $(DESTDIR)$(INSTALL_LIB)
	install -m 644 $(DYNAMIC_LIB) $(DESTDIR)$(INSTALL_LIB)/
	# Install headers
	install -d $(DESTDIR)$(INSTALL_INC)
	install -m 644 $(INCDIR)/*.h $(DESTDIR)$(INSTALL_INC)/
	# Install man pages
	install -d $(DESTDIR)$(INSTALL_MAN)
	install -m 644 $(MANDIR)/*.3 $(DESTDIR)$(INSTALL_MAN)/
	@echo "Installation completed successfully!"

# Uninstallation
uninstall:
	rm -f $(DESTDIR)$(INSTALL_BIN)/client
	rm -f $(DESTDIR)$(INSTALL_LIB)/lib$(LIBNAME).so
	rm -f $(DESTDIR)$(INSTALL_INC)/mystrfunctions.h
	rm -f $(DESTDIR)$(INSTALL_INC)/myfilefunctions.h
	rm -f $(DESTDIR)$(INSTALL_MAN)/mystrlen.3
	rm -f $(DESTDIR)$(INSTALL_MAN)/mystrcpy.3
	rm -f $(DESTDIR)$(INSTALL_MAN)/wordCount.3
	@echo "Uninstallation completed!"

# Clean build artifacts
clean:
	rm -rf $(OBJDIR) $(BINDIR) $(LIBDIR)

# Run targets
run: $(TARGET_DYNAMIC)
	LD_LIBRARY_PATH=$(LIBDIR):$(LD_LIBRARY_PATH) ./$(TARGET_DYNAMIC)

run-static: $(TARGET_STATIC)
	./$(TARGET_STATIC)

# View man pages
man-mystrlen:
	man -l man/man3/mystrlen.3

man-mystrcpy:
	man -l man/man3/mystrcpy.3

man-wordcount:
	man -l man/man3/wordCount.3

.PHONY: all static dynamic clean install uninstall run run-static man-mystrlen man-mystrcpy man-wordcount
