# This example CMakeLists.txt is taken from http://www.cmake.org/cmake/help/examples.html

# The name of our project is "HELLO". CMakeLists files in this project can 
# refer to the root source directory of the project as ${HELLO_SOURCE_DIR} and 
# to the root binary directory of the project as ${HELLO_BINARY_DIR}. 
cmake_minimum_required (VERSION 2.6) 
project (HELLO)

# Recurse into the "Hello" and "Demo" subdirectories. This does not actually 
# cause another cmake executable to run. The same process will walk through 
# the project's entire directory structure. 
add_subdirectory (Hello) 
add_subdirectory (Demo)

# Create a library called "Hello" which includes the source file "hello.cxx". 
# The extension is already found. Any number of sources could be listed here. 
add_library (Hello hello.cxx)

# Make sure the compiler can find include files from our Hello library. 
include_directories (${HELLO_SOURCE_DIR}/Hello) 

# Make sure the linker can find the Hello library once it is built. 
link_directories (${HELLO_BINARY_DIR}/Hello) 

# Add executable called "helloDemo" that is built from the source files 
# "demo.cxx" and "demo_b.cxx". The extensions are automatically found. 
add_executable (helloDemo demo.cxx demo_b.cxx) 

# Link the executable to the Hello library. 
target_link_libraries (helloDemo Hello) 
