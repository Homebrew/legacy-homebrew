require 'formula'

class Cmake <Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.3.tar.gz'
  md5 'a76a44b93acf5e3badda9de111385921'
  homepage 'http://www.cmake.org/'

  def install
    # If we specify to CMake to use the system libraries by passing
    # --system-libs to bootstrap then it insists on finding them all
    # or erroring out, as that's what other Linux/OSX distributions
    # would want. I've requested that they either fix this or let us
    # submit a patch to do so on their bug tracker:
    # http://www.cmake.org/Bug/view.php?id=11431
    inreplace 'CMakeLists.txt',
              "# Mention to the user what system libraries are being used.",
              "SET(CMAKE_USE_SYSTEM_XMLRPC 0)
               SET(CMAKE_USE_SYSTEM_LIBARCHIVE 0)"

    system "./bootstrap", "--prefix=#{prefix}",
                          "--system-libs",
                          "--datadir=/share/cmake",
                          "--docdir=/share/doc/cmake",
                          "--mandir=/share/man"
    system "make"
    system "make install"
  end
end
