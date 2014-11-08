require 'formula'

class GooglePerftools < Formula
  homepage 'http://code.google.com/p/gperftools/'
  url "https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/gperftools-2.2.1.tar.gz"
  sha1 "f505eb467bc5b55ea3a27e3386a70331bf6e38a0"

  bottle do
    cellar :any
    sha1 "c5f3fcc3e72965cdf5a60b3ff26e5b8fcc1f6bd2" => :yosemite
    sha1 "c930c122d93509860ed775647b6087ff47209646" => :mavericks
    sha1 "012d32851ca538fd32cd85db4fe8b033cfe38755" => :mountain_lion
  end

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  # * DATA is incorporated upstream, remove on next version update
  # * configure patch removes __thread support, which breaks tcmalloc since it internally calls malloc as well
  #   upstream: https://code.google.com/p/gperftools/issues/detail?id=573
  patch :DATA

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
