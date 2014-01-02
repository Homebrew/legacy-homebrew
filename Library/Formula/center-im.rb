require 'formula'

class CenterIm < Formula
  homepage 'http://www.centerim.org/index.php/Main_Page'
  url 'http://www.centerim.org/download/releases/centerim-4.22.10.tar.gz'
  sha1 '46fbac7a55f33b0d4f42568cca21ed83770650e5'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'jpeg' => :optional

  # Fix build with clang; 4.22.10 is an outdated release and 5.0 is a rewrite,
  # so this is not reported upstream
  def patches
    { :p1 => DATA,
      :p0 => "https://trac.macports.org/export/113135/trunk/dports/net/centerim/files/patch-libjabber_jconn.c.diff" }
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-msn"
    system "make install"
  end
end

__END__
diff --git a/libicq2000/libicq2000/sigslot.h b/libicq2000/libicq2000/sigslot.h
index b7509c0..024774f 100644
--- a/libicq2000/libicq2000/sigslot.h
+++ b/libicq2000/libicq2000/sigslot.h
@@ -82,6 +82,7 @@
 #ifndef SIGSLOT_H__
 #define SIGSLOT_H__
 
+#include <cstdlib>
 #include <set>
 #include <list>
 
