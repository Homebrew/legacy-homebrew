require 'brewkit'

class Cmake <Formula
  @url='http://www.cmake.org/files/v2.6/cmake-2.6.4.tar.gz'
  @md5='50f387d0436696c4a68b5512a72c9cde'
  @homepage='http://www.cmake.org/'

  def install
    # xmlrpc is a stupid little library, rather than waste our users' time
    # just let cmake use its own copy. God knows why something like cmake
    # needs an xmlrpc library anyway! It is amazing!
    inreplace 'CMakeLists.txt',
              "# Mention to the user what system libraries are being used.",
              "SET(CMAKE_USE_SYSTEM_XMLRPC 0)"

    system "./bootstrap", "--prefix=#{prefix}",
                          "--system-libs",
                          "--datadir=/share/cmake",
                          "--docdir=/share/doc/cmake",
                          "--mandir=/share/man"
    system "make install"
  end
end