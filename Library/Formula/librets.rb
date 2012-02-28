require 'formula'

class Librets < Formula
  url 'http://www.crt.realtors.org/projects/rets/librets/files/librets-1.5.2.tar.gz'
  homepage 'http://code.crt.realtors.org/projects/librets'
  md5 '74bcea0eb11f3c66cde5dc3ecea05224'

  depends_on 'boost'

  def install
    # allow compilation against the OSX-provided SWIG 1.3.31
    inreplace "configure",
      "        check=\"1.3.33\"",
      "        check=\"1.3.31\""

    inreplace "project/build/ac-macros/swig.m4",
      "    check=\"1.3.33\"",
      "    check=\"1.3.31\""

    # Allow compilation against boost 1.46.0
    inreplace "project/librets/src/RetsExceptionContext.cpp",
      "#include <boost/filesystem/path.hpp>",
      "#define BOOST_FILESYSTEM_VERSION 2\n#include <boost/filesystem/path.hpp>"

    # Snow Leopard's SWIG is detected as too old,
    # so disable language bindings.
    system "./configure", "--disable-debug",
                          "--enable-shared_dependencies",
                          "--prefix=#{prefix}",
                          "--disable-dotnet",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php",
                          "--disable-python"
    system "make install"
  end
end
