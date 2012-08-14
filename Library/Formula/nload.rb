require 'formula'

class Nload < Formula
  homepage 'http://www.roland-riegel.de/nload/'
  url 'http://www.roland-riegel.de/nload/nload-0.7.4.tar.gz'
  md5 '3c733c528f244ca5a4f76bf185729c39'

  fails_with :llvm do
    build 2334
  end

  depends_on :automake

  # Patching configure.in file to make configure compile on Mac OS.
  # Patch taken from MacPorts.
  def patches
    DATA
  end

  def install
    system "./run_autotools"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


__END__
diff --git a/configure.in b/configure.in
index 87ecc88..4df8dc3 100644
--- a/configure.in
+++ b/configure.in
@@ -38,7 +38,7 @@ case $host_os in
 
         AC_CHECK_FUNCS([memset])
         ;;
-    *bsd*)
+    *darwin*)
         AC_DEFINE(HAVE_BSD, 1, [Define to 1 if your build target is BSD.])
         AM_CONDITIONAL(HAVE_BSD, true)
