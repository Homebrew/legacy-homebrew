require 'formula'

class Cdlabelgen < Formula
  homepage 'http://www.aczoom.com/tools/cdinsert/'
  url 'http://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz'
  sha1 '1f7e1c34f7a5f409da19ca768a07778191264b19'

  depends_on 'jpeg2ps' => :recommended

  def install
    system "make", "install"
  end

  def patches
    # fix Makefile to install to /usr/local instead of /usr
    DATA
  end

  test do
    system "cdlabelgen -c TestTitle --output-file testout.eps"
    File.file?("testout.eps")
  end
end

__END__
diff --git a/Makefile b/Makefile
index c7a3977..63c72b4 100644
--- a/Makefile
+++ b/Makefile
@@ -10,8 +10,8 @@ ZIPVERSION = 430
 # Change these to locations you need, also
 # remember to edit cdlabelgen and its @where_is_the_template as needed.

-BASE_DIR   = /usr
-# BASE_DIR   = /usr/local
+# BASE_DIR   = /usr
+BASE_DIR   = /usr/local
 # BASE_DIR   = /opt
 BIN_DIR   = $(BASE_DIR)/bin
 LIB_DIR   = $(BASE_DIR)/share/cdlabelgen
