require "formula"

class Cpio < Formula
  homepage "http://www.gnu.org/software/cpio/"
  url "http://ftpmirror.gnu.org/cpio/cpio-2.11.tar.bz2"
  mirror "http://ftp.gnu.org/gnu/cpio/cpio-2.11.tar.bz2"
  sha1 "6f1934b0079dc1e85ddff89cabdf01adb3a74abb"

  # Fix the error:
  # ./stdio.h:358:1: error: 'gets' undeclared here (not in a function)
  # _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
  patch :DATA

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cpio --version"
  end
end

__END__
--- a/gnu/stdio.in.h  2010-03-10 09:27:03.000000000 +0000
+++ b/gnu/stdio.in.h  2014-11-08 16:56:30.000000000 +0000
@@ -139,7 +139,9 @@
    so any use of gets warrants an unconditional warning.  Assume it is
    always declared, since it is required by C89.  */
 #undef gets
+#ifdef HAVE_RAW_DECL_GETS
 _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
+#endif
 
 #if @GNULIB_FOPEN@
 # if @REPLACE_FOPEN@
