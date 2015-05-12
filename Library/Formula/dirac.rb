class Dirac < Formula
  homepage "http://diracvideo.org/"
  url "http://diracvideo.org/download/dirac-research/dirac-1.0.2.tar.gz"
  sha256 "816b16f18d235ff8ccd40d95fc5b4fad61ae47583e86607932929d70bf1f00fd"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  fails_with :llvm do
    build 2334
  end

  patch :DATA

  def install
    # BSD cp doesn't have "-d"
    inreplace "doc/Makefile.in", "cp -dR", "cp -R"

    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
__END__
diff --git a/bootstrap b/bootstrap
index 61f7c11..812148d 100755
--- a/bootstrap
+++ b/bootstrap
@@ -11,7 +11,7 @@ rm -rf autom4te.cache
 
 set -x
 aclocal -I m4
-libtoolize --force --copy
+glibtoolize --force --copy
 automake --foreign --copy --add-missing
 if [ $? -ne 0 ]; 
 then
