# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/ubuntu/custom

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/ubuntu/custom/build

# Utility rule file for all_pch.

# Include the progress variables for this target.
include CMakeFiles/all_pch.dir/progress.make

CMakeFiles/all_pch:

all_pch: CMakeFiles/all_pch
all_pch: CMakeFiles/all_pch.dir/build.make
.PHONY : all_pch

# Rule to build all files generated by this target.
CMakeFiles/all_pch.dir/build: all_pch
.PHONY : CMakeFiles/all_pch.dir/build

CMakeFiles/all_pch.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/all_pch.dir/cmake_clean.cmake
.PHONY : CMakeFiles/all_pch.dir/clean

CMakeFiles/all_pch.dir/depend:
	cd /home/ubuntu/custom/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/ubuntu/custom /home/ubuntu/custom /home/ubuntu/custom/build /home/ubuntu/custom/build /home/ubuntu/custom/build/CMakeFiles/all_pch.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/all_pch.dir/depend

