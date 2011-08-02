require 'formula'

class Nload < Formula
  url 'http://www.roland-riegel.de/nload/nload-0.7.3.tar.gz'
  homepage 'http://www.roland-riegel.de/nload/'
  md5 '9b97c37fe1474f1da42f265fead24081'

  fails_with_llvm

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
