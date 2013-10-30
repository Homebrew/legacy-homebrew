require 'formula'

# TODO rename to gperftools when renames are supported
class GooglePerftools < Formula
  homepage 'http://code.google.com/p/gperftools/'
  url 'http://gperftools.googlecode.com/files/gperftools-2.1.tar.gz'
  sha1 'b799b99d9f021988bbc931db1c21b2f94826d4f0'

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  # Incorporated upstream, remove on next version update
  def patches
    DATA
  end

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
--- a/src/static_vars.cc
+++ b/src/static_vars.cc
@@ -37,6 +37,7 @@
 #include "common.h"
 #include "sampler.h"           // for Sampler
 #include "base/googleinit.h"
+#include <pthread.h>

 namespace tcmalloc {
