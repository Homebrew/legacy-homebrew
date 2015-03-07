# C++ Standard Libraries
There are two C++ standard libraries supported by Apple compilers.

The default for 10.8 and earlier is **libstdc++**, supported by Apple GCC compilers, GNU GCC compilers, and clang.

The default for 10.9 is **libc++**, which is also the default for clang on older platforms when building C++11 code.

There are subtle incompatibilities between several of the C++ standard libraries, so Homebrew will refuse to install software if a dependency was built with an incompatible C++ library. It's recommended that you install the dependency tree using a compatible compiler.

**If you've upgraded to 10.9 from an earlier version** - because the default C++ standard library is now libc++, you may not be able to build software using dependencies that you built on 10.8 or lower. If you're reading this page because you were directed here by a build error, you can most likely fix the issue if you reinstall all the dependencies of the package you're trying to build.

Example install using GCC 4.8: ```brew install DESIRED_FORMULA --cc=gcc-4.8```.
Get GCC 4.8 via: ```brew install gcc48```
