require 'formula'

class Cmake <Formula
  url 'http://www.cmake.org/files/v2.8/cmake-2.8.1.tar.gz'
  md5 'feadc2e5ebbfed0efc90178583503725'
  homepage 'http://www.cmake.org/'

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
    system "make" # Separate steps, or compile fails on Mac Pro
    system "make install"
  end
end
