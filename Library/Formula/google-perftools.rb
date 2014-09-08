require 'formula'

class GooglePerftools < Formula
  homepage 'http://code.google.com/p/gperftools/'
  url 'https://gperftools.googlecode.com/files/gperftools-2.1.tar.gz'
  sha1 'b799b99d9f021988bbc931db1c21b2f94826d4f0'

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  # * DATA is incorporated upstream, remove on next version update
  # * configure patch removes __thread support, which breaks tcmalloc since it internally calls malloc as well
  #   upstream: https://code.google.com/p/gperftools/issues/detail?id=573
  patch :DATA
  patch do
    url "https://gist.githubusercontent.com/JustSid/7430366/raw/54979ac61602eec5e59223164cb1f0d136044d1f/gistfile1.txt"
    sha1 "4fde81e106b31198622db587fea51f01e2640789"
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
