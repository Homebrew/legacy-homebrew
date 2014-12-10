require 'formula'

class Blitzwave < Formula
  homepage 'http://oschulz.github.io/blitzwave'
  url 'https://github.com/oschulz/blitzwave/archive/v0.8.0.tar.gz'
  sha1 '16d96f28ba295659301ab6485782715786fd496e'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "blitz"

  # an automake tweak to fix compiling
  # reported upstream: https://github.com/oschulz/blitzwave/issues/2
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 8d28d78..2bfe06f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,7 @@ AM_INIT_AUTOMAKE([-Wall -Werror])
 AC_PROG_CXX
 AC_LIBTOOL_DLOPEN
 AC_PROG_LIBTOOL
+AM_PROG_AR

 AC_CHECK_PROGS(DOXYGEN, doxygen, false)
 AM_CONDITIONAL([COND_DOXYGEN], [test "$DOXYGEN" != "false"])
