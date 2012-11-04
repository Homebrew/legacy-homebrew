require 'formula'

class Abiword < Formula
  homepage 'http://www.abisource.com/'
  url 'http://www.abisource.com/downloads/abiword/2.8.6/source/abiword-2.8.6.tar.gz'
  sha1 '998f69d038000b3fc027d4259548f02d67c8d0df'

  devel do
    url 'http://www.abisource.com/downloads/abiword/2.9.2/source/abiword-2.9.2.tar.gz'
    sha1 '34a6e4e9c5619e8f2d619ac844519fc9378405b3'
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

  def patches
    if build.devel?
      {:p0 => "http://bugzilla.abisource.com/attachment.cgi?id=5477"}
    else
      DATA
    end
  end

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
