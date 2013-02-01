require 'formula'

class Abiword < Formula
  homepage 'http://www.abisource.com/'
  url 'http://www.abisource.com/downloads/abiword/2.8.6/source/abiword-2.8.6.tar.gz'
  sha1 '998f69d038000b3fc027d4259548f02d67c8d0df'

  devel do
    url 'http://www.abisource.com/downloads/abiword/2.9.4/source/abiword-2.9.4.tar.gz'
    sha1 '67cfbc633129128a1aa48ffba8959229cef2ebdd'
  end

  depends_on :libpng
  depends_on 'jpeg'
  depends_on 'fribidi'
  depends_on 'libgsf'
  depends_on 'enchant'
  depends_on 'cairo'
  depends_on 'pango'
  depends_on 'wv'
  depends_on 'imagemagick'

  fails_with :clang do
    build 421
    cause "error: static_cast from 'id' to 'XAP_Menu_Id' (aka 'int') is not allowed"
  end

  def patches
    {
      # Fixes newer libpng versions; needed for libpng 1.2, too
      :p0 => "https://trac.macports.org/export/102401/trunk/dports/editors/abiword-x11/files/patch-libpng-1.5.diff",
      # Fixes bad glib include
      :p1 => DATA
    }
  end if build.stable?

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/af/util/xp/ut_go_file.h b/src/af/util/xp/ut_go_file.h
index e29d7b7..8d5f608 100644
--- a/src/af/util/xp/ut_go_file.h
+++ b/src/af/util/xp/ut_go_file.h
@@ -31,7 +31,6 @@
 
 #include <glib.h>
 #include <gsf/gsf.h>
-#include <glib/gerror.h>
 #include <time.h>
 
 G_BEGIN_DECLS
