# Operating Systems Assignment - Report

**Student:** Moawiz Sipra
**Roll No:** BSDSF24A036
**Repository:** BSDSF24A036-OS-A01

---

## Part 2: Multi-file Project using Make Utility

### Q1: Explain the linking rule in this part's Makefile: `$(TARGET): $(OBJECTS)`. How does it differ from a Makefile rule that links against a library?

**Answer:**
The linking rule `$(TARGET): $(OBJECTS)` links all object files directly into a single executable. It combines `main.o`, `mystfunctions.o`, and `myfilefunctions.o` into one binary. The linker resolves all symbols at this stage because all object files are provided directly.

In contrast, a Makefile rule that links against a library (e.g., `$(TARGET): $(OBJECTS) -L$(LIB_DIR) -lmyutils`) links the main object file with a pre-built library (`.a` or `.so`). The linker only pulls in the required object files from the library, and the library must exist before linking. This is more modular and scalable.

---

### Q2: What is a git tag and why is it useful in a project? What is the difference between a simple tag and an annotated tag?

**Answer:**
A **git tag** is a reference to a specific commit in the repository's history, used to mark important points like releases (e.g., `v0.1.0`). It is useful for versioning, releasing software, and referring back to stable versions.

- **Simple (lightweight) tag:** Just a pointer to a commit. No extra information. Created with `git tag <name>`.
- **Annotated tag:** Stores extra metadata like tagger name, email, date, and a message. Created with `git tag -a <name> -m "message"`. Annotated tags are preferred for releases because they are verifiable and contain more information.

---

### Q3: What is the purpose of creating a "Release" on GitHub? What is the significance of attaching binaries (like your client executable) to it?

**Answer:**
A **GitHub Release** is a way to package and distribute a specific version of the software. It creates a snapshot of the code at a tag, along with release notes and downloadable assets. It makes it easy for users to download and use the software without cloning the repository.

Attaching binaries (like `client`) is significant because:
- Users don't need to compile the code themselves.
- It provides a ready-to-run executable for the specific version.
- It serves as an official distribution point for the software.

---

## Part 3: Creating and using Static Library

### Q1: Compare the Makefile from Part 2 and Part 3. What are the key differences in the variables and rules that enable the creation of a static library?

**Answer:**
In Part 2, all `.c` files were compiled and linked directly into one executable. The Makefile had a single linking rule `$(TARGET): $(OBJS)` where `$(OBJS)` contained all object files including `main.o`.

In Part 3, the Makefile was modified to:
1. Separate `main.o` from the library object files (`mystfunctions.o`, `myfilefunctions.o`).
2. Add a new variable `$(LIBRARY) = lib/libmyutils.a`.
3. Add a rule `$(LIBRARY): $(LIB_OBJS)` that uses `ar rcs` to create the static library.
4. Modify the linking rule to `$(TARGET): $(MAIN_OBJ) $(LIBRARY)` which links `main.o` with the static library using `-L$(LIB_DIR) -lmyutils`.

The key difference is the use of `ar` to archive object files into a `.a` file, and the linker pulling only the needed object files from the archive.

---

### Q2: What is the purpose of the `ar` command? Why is `ranlib` often used immediately after it?

**Answer:**
The `ar` (archiver) command is used to create, modify, and extract from archives (`.a` files). It bundles multiple object files into a single static library.

`ranlib` is used to generate an index (symbol table) for the archive. This index speeds up linking by allowing the linker to quickly find which object file defines a symbol. In modern systems, `ar rcs` (with the `s` flag) automatically generates this index, so `ranlib` is often not needed separately. However, in older systems, `ranlib` was run after `ar` to create the index.

---

### Q3: When you run `nm` on your `client_static` executable, are the symbols for functions like `mystrlen` present? What does this tell you about how static linking works?

**Answer:**
Yes, when running `nm bin/client_static | grep mystrlen`, the symbol `mystrlen` appears as a defined symbol (e.g., `T mystrlen`). This tells us that in static linking, the code for `mystrlen` is **copied directly into the executable** at link time. The executable becomes self-contained and does not need the library at runtime. This is why static executables are larger but more portable.

---

## Part 4: Dynamic Library

### Q1: What is Position-Independent Code (-fPIC) and why is it a fundamental requirement for creating shared libraries?

**Answer:**
**Position-Independent Code (PIC)** is machine code that can be loaded at any memory address without modification. It uses relative addressing instead of absolute addresses.

It is a fundamental requirement for shared libraries because:
- Shared libraries are loaded at runtime at unpredictable addresses.
- Without PIC, the library would need to be loaded at a fixed address, which is not feasible when multiple libraries are loaded.
- PIC allows the same library code to be shared by multiple processes at different addresses.

The `-fPIC` flag tells `gcc` to generate position-independent code.

---

### Q2: Explain the difference in file size between your static and dynamic clients. Why does this difference exist?

**Answer:**
- `client_static`: 23K
- `client_dynamic`: 20K

The static client is larger because it includes the full code of `mystfunctions.o` and `myfilefunctions.o` copied into the executable. The dynamic client is smaller because it only contains references (stubs) to the library functions, and the actual code resides in `libmyutils.so`, which is loaded at runtime.

This difference exists because static linking copies library code into the executable, while dynamic linking only stores a reference to the shared library.

---

### Q3: What is the LD_LIBRARY_PATH environment variable? Why was it necessary to set it for your program to run, and what does this tell you about the responsibilities of the operating system's dynamic loader?

**Answer:**
`LD_LIBRARY_PATH` is an environment variable that tells the dynamic loader (`ld.so`) where to search for shared libraries at runtime, in addition to the standard paths (`/lib`, `/usr/lib`, etc.).

It was necessary to set it because our custom `libmyutils.so` was in the project's `lib/` directory, which is not a standard system path. Without setting `LD_LIBRARY_PATH`, the loader could not find `libmyutils.so` and the program failed with "cannot open shared object file".

This tells us that the **dynamic loader** is responsible for:
1. Finding shared libraries at runtime.
2. Loading them into memory.
3. Resolving symbols (like `mystrlen`, `mygrep`) to their actual addresses in the loaded library.
4. If the library is not found, the program fails to start.

---

## Part 5: Man Pages & Installation

### Q1: What is the purpose of man pages? What sections did you include in your man page?

**Answer:**
**Man pages** (manual pages) are the standard documentation system on Unix/Linux. They provide detailed information about commands, functions, system calls, and file formats. They are accessed via the `man` command.

In my man page (`man/man3/client.3`), I included the following sections:
- **.TH**: Title header (name, section, date, version)
- **.SH NAME**: Name and one-line description
- **.SH SYNOPSIS**: How the command is called
- **.SH DESCRIPTION**: Detailed explanation
- **.SH FUNCTIONS TESTED**: List of functions tested by the client
- **.SH AUTHOR**: Author name and email

---

### Q2: What does the install target in your Makefile do?

**Answer:**
The `install` target in the Makefile:
1. Creates `/usr/local/bin/` and installs `client_dynamic` as `/usr/local/bin/client`.
2. Creates `/usr/local/lib/` and installs `libmyutils.so` there.
3. Creates `/usr/local/share/man/man3/` and installs the man pages.
4. Runs `ldconfig` to update the system's shared library cache.

This simulates how a real software package is installed system-wide.

---

## Conclusion

This assignment helped me understand:
- The complete C compilation process (preprocessing, compilation, assembly, linking)
- Static vs dynamic libraries and their trade-offs
- Makefile creation and automation
- Git branching, tagging, and GitHub releases
- Man page creation and installation
- Binary analysis tools (`nm`, `readelf`, `ldd`, `ar`)

All parts of the assignment were completed successfully.
