# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.25

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = D:\VScode\cmake\bin\cmake.exe

# The command to remove a file.
RM = D:\VScode\cmake\bin\cmake.exe -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = D:\VScode\Codeproject\project

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = D:\VScode\Codeproject\project\build

# Include any dependencies generated for this target.
include CMakeFiles/h.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/h.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/h.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/h.dir/flags.make

CMakeFiles/h.dir/main.cpp.obj: CMakeFiles/h.dir/flags.make
CMakeFiles/h.dir/main.cpp.obj: D:/VScode/Codeproject/project/main.cpp
CMakeFiles/h.dir/main.cpp.obj: CMakeFiles/h.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=D:\VScode\Codeproject\project\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/h.dir/main.cpp.obj"
	D:\VScode\code\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/h.dir/main.cpp.obj -MF CMakeFiles\h.dir\main.cpp.obj.d -o CMakeFiles\h.dir\main.cpp.obj -c D:\VScode\Codeproject\project\main.cpp

CMakeFiles/h.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/h.dir/main.cpp.i"
	D:\VScode\code\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E D:\VScode\Codeproject\project\main.cpp > CMakeFiles\h.dir\main.cpp.i

CMakeFiles/h.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/h.dir/main.cpp.s"
	D:\VScode\code\mingw64\bin\g++.exe $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S D:\VScode\Codeproject\project\main.cpp -o CMakeFiles\h.dir\main.cpp.s

# Object files for target h
h_OBJECTS = \
"CMakeFiles/h.dir/main.cpp.obj"

# External object files for target h
h_EXTERNAL_OBJECTS =

h.exe: CMakeFiles/h.dir/main.cpp.obj
h.exe: CMakeFiles/h.dir/build.make
h.exe: CMakeFiles/h.dir/linkLibs.rsp
h.exe: CMakeFiles/h.dir/objects1
h.exe: CMakeFiles/h.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=D:\VScode\Codeproject\project\build\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable h.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\h.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/h.dir/build: h.exe
.PHONY : CMakeFiles/h.dir/build

CMakeFiles/h.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\h.dir\cmake_clean.cmake
.PHONY : CMakeFiles/h.dir/clean

CMakeFiles/h.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" D:\VScode\Codeproject\project D:\VScode\Codeproject\project D:\VScode\Codeproject\project\build D:\VScode\Codeproject\project\build D:\VScode\Codeproject\project\build\CMakeFiles\h.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/h.dir/depend
