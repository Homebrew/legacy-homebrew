require 'formula'

class Rtorrent <Formula
  url 'http://libtorrent.rakshasa.no/downloads/rtorrent-0.8.5.tar.gz'
  homepage 'http://libtorrent.rakshasa.no/'
  md5 'e701095e1824b7e512a17000f4c0a783'

  depends_on 'pkg-config'
  depends_on 'libsigc++'
  depends_on 'libtorrent'

  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

__END__
diff -u a/configure b/configure
--- a/configure	2009-10-14 19:28:31.000000000 -0700
+++ b/configure	2009-10-14 19:27:36.000000000 -0700
@@ -17686,7 +17686,7 @@
   ac_status=$?
   $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
   (exit $ac_status); }; then
-  pkg_cv_libcurl_LIBS=`$PKG_CONFIG --libs "libcurl >= 7.15.4" 2>/dev/null`
+  pkg_cv_libcurl_LIBS=`$PKG_CONFIG --libs-only-l "libcurl >= 7.15.4" 2>/dev/null`
 else
   pkg_failed=yes
 fi
