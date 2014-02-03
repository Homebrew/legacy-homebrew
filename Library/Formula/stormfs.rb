require 'formula'

class Stormfs < Formula
  homepage 'https://github.com/benlemasurier/stormfs'
  url 'https://github.com/downloads/benlemasurier/stormfs/stormfs-0.01.tar.gz'
  sha1 'd86bb74beb4b4343b63b3eda3e6bd6f4db982bbb'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'fuse4x'
  depends_on 'curl' if MacOS.version <= :leopard

  def patches; DATA; end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/curl.c b/src/curl.c
index de43059..0b02053 100644
--- a/src/curl.c
+++ b/src/curl.c
@@ -23,7 +23,6 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <curl/curl.h>
-#include <curl/types.h>
 #include <curl/easy.h>
 #include <pthread.h>
 #include <glib.h>
