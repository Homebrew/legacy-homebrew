class Libkml < Formula
  desc "Library to parse, generate and operate on KML"
  homepage "https://code.google.com/p/libkml/"

  stable do
    url "https://libkml.googlecode.com/files/libkml-1.2.0.tar.gz"
    sha256 "fae9085e4cd9f0d4ae0d0626be7acf4ad5cbb37991b9d886df29daf72df37cbc"

    # Correct an issue where internal third-party libs (libminizip and liburiparser)
    # are installed as dylibs. liburiparser conflicts with uriparser formula.
    # libminizip conflicts with new formula, and some of its symbols have been
    # renamed with prefixes of "libkml_", i.e, can't be linked against for other builds
    # Fix just forces internal libs to be linked statically until the following
    # is addressed upstream: https://code.google.com/p/libkml/issues/detail?id=50
    patch do
      url "https://gist.githubusercontent.com/dakcarto/7419882/raw/10ae08af224b3fee0617fa6288d806d3ccf37c0f/libkml-1.2-static-deps"
      sha256 "c39995a1c1ebabc1692dc6be698d68e18170230d71d5a0ce426d8f41bdf0dc72"
    end
  end

  bottle do
    cellar :any
    revision 2
    sha256 "57b9693cdf9a6abaeeea9648cd84a81d17ba0f056bd8d8e8442e68d97dbc7828" => :el_capitan
    sha256 "a3cdfca3ed0acbc93949683a8bb2862c36ec8bf06f20b9fe3752ac624667f455" => :yosemite
    sha256 "22c4df9a8f64f8c6ec300cfb268994d739ff41e80db44ca3a72358fc4b70bc05" => :mavericks
  end

  head do
    url "https://libkml.googlecode.com/svn/trunk/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # see stable patch
    patch do
      url "https://gist.githubusercontent.com/dakcarto/7420023/raw/65cdb088c91a7da844251e348eeda8df1d903f1d/libkml-svn-static-deps"
      sha256 "a85abf19e364ea745a5bbc9a24bf580058acaea98cf129adf28fc5bb0627f253"
    end
  end

  # Fix compilation with clang and gcc 4.7+
  # https://code.google.com/p/libkml/issues/detail?id=179
  patch :DATA

  def install
    if build.head?
      # The inreplace line below is only required until the patch in #issue 186
      # is applied. https://code.google.com/p/libkml/issues/detail?id=186
      # If the patch is applied, this find and replace will be unnecessary, but also
      # harmless
      inreplace "configure.ac", "-Werror", ""

      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
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
 
