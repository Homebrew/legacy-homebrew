require 'formula'

class Rlog < Formula
  homepage 'http://www.arg0.net/rlog'
  url 'http://rlog.googlecode.com/files/rlog-1.4.tar.gz'
  sha1 '9cd86b4ceec3988f0a17730a8987110233797dcd'

  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

# This patch solves an OSX build issue, should not be necessary for the next release according to
# http://code.google.com/p/rlog/issues/detail?id=7
__END__
--- orig/rlog/common.h.in	2008-06-14 20:10:13.000000000 -0700
+++ new/rlog/common.h.in	2009-05-18 16:05:04.000000000 -0700
@@ -52,7 +52,12 @@
 
 # define PRINTF(FMT,X) __attribute__ (( __format__ ( __printf__, FMT, X)))
 # define HAVE_PRINTF_ATTR 1
+
+#ifdef __APPLE__ 
+# define RLOG_SECTION __attribute__ (( section("__DATA, RLOG_DATA") ))
+#else
 # define RLOG_SECTION __attribute__ (( section("RLOG_DATA") ))
+#endif
 
 #if __GNUC__ >= 3
 # define expect(foo, bar) __builtin_expect((foo),bar)
