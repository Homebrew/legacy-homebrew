require 'formula'

class Binutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.23.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.23.2.tar.gz'
  sha1 'c3fb8bab921678b3e40a14e648c89d24b1d6efec'

  # Fix compilation with clang. Reported upstream:
  # http://sourceware.org/bugzilla/show_bug.cgi?id=15728
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make install"
  end
end

__END__
--- a/include/cgen/basic-ops.h	2009-10-23 18:17:08.000000000 -0600
+++ b/include/cgen/basic-ops.h	2013-07-10 14:21:44.000000000 -0600
@@ -295,11 +295,11 @@
    significant and word number 0 is the most significant word.
    ??? May also wish an endian-dependent version.  Later.  */
 
-QI SUBWORDSIQI (SI, int);
-HI SUBWORDSIHI (SI, int);
-QI SUBWORDDIQI (DI, int);
-HI SUBWORDDIHI (DI, int);
-SI SUBWORDDISI (DI, int);
+static QI SUBWORDSIQI (SI, int);
+static HI SUBWORDSIHI (SI, int);
+static QI SUBWORDDIQI (DI, int);
+static HI SUBWORDDIHI (DI, int);
+static SI SUBWORDDISI (DI, int);
 
 #ifdef SEMOPS_DEFINE_INLINE
