require 'formula'

class Trafficserver < Formula
  url 'http://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-3.0.2.tar.bz2'
  homepage 'http://trafficserver.apache.org/'
  md5 '0f8e5ce658d28511001c6585d1e1813a'

  depends_on 'pcre'

  def patches
      # configure script seems to erroneously detect ac_cv_gethostbyname_r_style=glibc2
      DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-user=#{ENV['USER']}", "--with-group=admin"
    system "make install"
  end

  def test
    system "trafficserver status"
  end
end

__END__
--- a/configure.2012-01-05-162306	2011-12-04 13:57:42.000000000 -0800
+++ b/configure	2012-01-05 16:24:04.000000000 -0800
@@ -21533,7 +21533,7 @@
      return 0; }
 _ACEOF
 if ac_fn_c_try_compile "$LINENO"; then :
-  ac_cv_gethostbyname_r_style=glibc2
+  ac_cv_gethostbyname_r_style=none
 else
   ac_cv_gethostbyname_r_style=none
 fi
