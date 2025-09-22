# Operating Systems Assignment 01 Report
**Roll Number:** BSDSF23A026
**Name:** Muhammad Mujtaba

## Part 2: Multi-file Project

### 1. Linking Rule Explanation
The rule `$(TARGET): $(OBJECTS)` creates a direct dependency between the executable and all object files. When any source file changes, the corresponding object file is recompiled and the executable is relinked. This differs from library linking where we specify library paths (`-L`) and library names (`-l`) to link against pre-built archives.

### 2. Git Tags Purpose
Git tags mark specific commits as important milestones (typically releases). Annotated tags store metadata like author, date, and message, making them suitable for versioning. Simple tags are just pointers to commits without additional information.

### 3. GitHub Releases Purpose
Releases package specific code versions with compiled binaries, documentation, and release notes. This allows users to download ready-to-use software without needing to build from source, improving accessibility.

## Part 3: Static Library

### 1. Makefile Differences
Key differences from Part 2:
- Added library creation rules using `ar` and `ranlib`
- Separate compilation of library objects vs main program
- Used `-L$(LIBDIR) -l$(LIBNAME)` for linking instead of direct object linking
- Introduced library-specific variables and targets

### 2. ar and ranlib Purpose
`ar` (archiver) creates static libraries by bundling object files into a single archive. `ranlib` generates an index of symbols in the archive, making linking faster by allowing the linker to quickly locate needed functions.

### 3. Symbol Analysis with nm
When running `nm` on `client_static`, the symbols for functions like `mystrlen` are present in the executable. This demonstrates that static linking copies the actual function code into the final binary, making it self-contained but larger in size.

## Part 4: Dynamic Library

### 1. Position-Independent Code (-fPIC)
PIC allows code to be loaded at any memory address without modification. This is essential for shared libraries because multiple processes can share the same library code loaded at different addresses. Without PIC, each process would need its own copy of the library.

### 2. File Size Difference
The dynamic client is significantly smaller than the static client because it contains only the main program code and references to external functions. The actual library code remains separate and is loaded at runtime. The static client includes all library code within the executable.

### 3. LD_LIBRARY_PATH Purpose
`LD_LIBRARY_PATH` tells the dynamic loader where to search for shared libraries at runtime. It was necessary because our custom library isn't in standard system locations. This shows that the dynamic loader is responsible for locating and loading required libraries when a program starts.

## Part 5: Man Pages and Installation

### 1. Man Page Structure
Man pages use groff markup with standard sections: NAME, SYNOPSIS, DESCRIPTION, RETURN VALUE, EXAMPLES, and AUTHOR. This standardized format ensures consistency across Unix/Linux documentation.

### 2. Installation Process
The `install` target copies binaries to `/usr/local/bin`, libraries to `/usr/local/lib`, headers to `/usr/local/include`, and man pages to `/usr/local/share/man`. This follows Linux Filesystem Hierarchy Standard conventions.

## Learning Outcomes
This assignment provided comprehensive experience with C project structure, build systems, library creation, and professional development workflows. The step-by-step approach from multi-file compilation to dynamic libraries demonstrated the evolution of software packaging and distribution.
