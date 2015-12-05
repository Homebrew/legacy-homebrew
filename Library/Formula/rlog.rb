class Rlog < Formula
  desc "Flexible message logging facility for C++"
  homepage "http://www.arg0.net/rlog"
  url "https://rlog.googlecode.com/files/rlog-1.4.tar.gz"
  sha256 "a938eeedeb4d56f1343dc5561bc09ae70b24e8f70d07a6f8d4b6eed32e783f79"

  bottle do
    cellar :any
    sha256 "c95d8998639fd75131f923191eaa857bc3ff8f33ee64ca3b5d459ac1979e6fa2" => :el_capitan
    sha256 "44f3b8ee89802fb13674e3b60e873045a459bf13513b84f3f7b94c8a4444b2eb" => :yosemite
    sha256 "70c1faaac613087604231c7e30ba5dd458183c1dec4cfccb73b25a32fee6c603" => :mavericks
  end

  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

# This patch solves an OSX build issue, should not be necessary for the next release according to
# https://code.google.com/p/rlog/issues/detail?id=7
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
