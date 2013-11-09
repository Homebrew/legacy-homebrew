require 'formula'

class Libkml < Formula
  homepage 'http://code.google.com/p/libkml/'
  url 'http://libkml.googlecode.com/files/libkml-1.2.0.tar.gz'
  sha1 '3fa5acdc2b2185d7f0316d205002b7162f079894'

  head do
    url 'http://libkml.googlecode.com/svn/trunk/'

    depends_on :automake
    depends_on :libtool
  end

  # Fix compilation with clang and gcc 4.7+
  # https://code.google.com/p/libkml/issues/detail?id=179
  def patches; DATA; end

  def install
    if build.head?
      # The inreplace line below is only required until the patch in #issue 186
      # is applied. http://code.google.com/p/libkml/issues/detail?id=186
      # If the patch is applied, this find and replace will be unnecessary, but also
      # harmless
      inreplace 'configure.ac', '-Werror', ''

      # Compatibility with Automake 1.13 and newer.
      inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADER'

      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/kml/base/file_posix.cc b/src/kml/base/file_posix.cc
index 764ae55..8ee9892 100644
--- a/src/kml/base/file_posix.cc
+++ b/src/kml/base/file_posix.cc
@@ -29,6 +29,7 @@
 #include "kml/base/file.h"
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
