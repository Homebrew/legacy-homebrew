require 'formula'

class Ftimes < Formula
  url 'http://downloads.sourceforge.net/project/ftimes/ftimes/3.8.0/ftimes-3.8.0.tgz'
  homepage 'http://ftimes.sourceforge.net/FTimes/index.shtml'
  md5 'b4bc8a3c00b3aed9e9cc9583234ec6a7'

  depends_on 'pcre'
  depends_on 'openssl'

  # puts man page under /[prefix]/share/man; --mandir flag does not work
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index e05b3c2..589a824 100755
--- a/configure
+++ b/configure
@@ -349,7 +349,7 @@ libdir='${exec_prefix}/lib'
 includedir='${prefix}/include'
 oldincludedir='/usr/include'
 infodir='${prefix}/info'
-mandir='${prefix}/man'
+mandir='${prefix}/share/man'
 
 ac_prev=
 for ac_option
