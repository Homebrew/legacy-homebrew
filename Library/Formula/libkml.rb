require 'formula'

class Libkml < Formula
  homepage 'http://code.google.com/p/libkml/'

  stable do
    url "https://libkml.googlecode.com/files/libkml-1.2.0.tar.gz"
    sha1 "3fa5acdc2b2185d7f0316d205002b7162f079894"

    # Correct an issue where internal third-party libs (libminizip and liburiparser)
    # are installed as dylibs. liburiparser conflicts with uriparser formula.
    # libminizip conflicts with new formula, and some of its symbols have been
    # renamed with prefixes of "libkml_", i.e, can't be linked against for other builds
    # Fix just forces internal libs to be linked statically until the following
    # is addressed upstream: https://code.google.com/p/libkml/issues/detail?id=50
    patch do
      url "https://gist.githubusercontent.com/dakcarto/7419882/raw/10ae08af224b3fee0617fa6288d806d3ccf37c0f/libkml-1.2-static-deps"
      sha1 "eba47421e64e75bcf68026bbbe7c985b3bebcde5"
    end
  end

  bottle do
    cellar :any
    sha1 "fd05eca1ca215f88295488af18b2d1c1e410b7a7" => :mavericks
    sha1 "0a83c29449cf8b6af9770d04dcad2d65c2d1cc0a" => :mountain_lion
    sha1 "0dcde8dbaf1d05fb30e617c84ba13bd5ad9df289" => :lion
  end

  head do
    url 'http://libkml.googlecode.com/svn/trunk/'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # see stable patch
    patch do
      url "https://gist.githubusercontent.com/dakcarto/7420023/raw/65cdb088c91a7da844251e348eeda8df1d903f1d/libkml-svn-static-deps"
      sha1 "9ef82d73199325e63596c28c6965ec8c151bf7c5"
    end
  end

  # Fix compilation with clang and gcc 4.7+
  # https://code.google.com/p/libkml/issues/detail?id=179
  patch :DATA

  def install
    if build.head?
      # The inreplace line below is only required until the patch in #issue 186
      # is applied. http://code.google.com/p/libkml/issues/detail?id=186
      # If the patch is applied, this find and replace will be unnecessary, but also
      # harmless
      inreplace 'configure.ac', '-Werror', ''

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
 
