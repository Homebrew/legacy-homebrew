require 'formula'

class Libzzip < Formula
  url 'http://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.60/zziplib-0.13.60.tar.bz2'
  homepage 'http://sourceforge.net/projects/zziplib/'
  sha1 '821ff9a7984ddccb6734e4a753e401e93c7d47ee'

  depends_on 'pkg-config' => :build

  def patches
    # Darwin links with libtool, and when the compiler is clang or gcc-4.6, link fails:
    #    clang: error: unsupported option '--export-dynamic'
    # Reported upstream and patch submitted.
    #   https://sourceforge.net/tracker/?func=detail&aid=3496704&group_id=6389&atid=306389
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
    ENV.deparallelize     # fails without this when a compressed file isn't ready.
    system "make check"   # runing this after install bypasses DYLD issues.
  end
end

__END__
--- a/configure	2010-12-29 08:07:16.000000000 -0800
+++ b/configure	2012-03-03 20:28:28.000000000 -0800
@@ -13715,10 +13715,17 @@
 ZZIPLIB_LDFLAGS=""
 test ".$can_build_shared" != ".no" && ZZIPLIB_LDFLAGS="--export-dynamic"
 RESOLVES=" # "
-case "$host_os" in mingw*)
+case "$host_os" in
+  mingw*)
     ZZIPLIB_LDFLAGS="-no-undefined -export-all-symbols -mconsole"
     RESOLVES=' '
-;; esac
+  ;;
+  # Darwin links with libtool, and when the compiler is clang or gcc-4.6,
+  #   clang: error: unsupported option '--export-dynamic'
+  darwin*)
+    ZZIPLIB_LDFLAGS="-export-dynamic"
+  ;;
+esac
 { $as_echo "$as_me:${as_lineno-$LINENO}: result: $ZZIPLIB_LDFLAGS $RESOLVES" >&5
 $as_echo "$ZZIPLIB_LDFLAGS $RESOLVES" >&6; }
 
