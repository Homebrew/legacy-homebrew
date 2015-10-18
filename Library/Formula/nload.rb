class Nload < Formula
  desc "Realtime console network usage monitor"
  homepage "http://www.roland-riegel.de/nload/"
  url "http://www.roland-riegel.de/nload/nload-0.7.4.tar.gz"
  sha256 "c1c051e7155e26243d569be5d99c744d8620e65fa8a7e05efcf84d01d9d469e5"

  fails_with :llvm do
    build 2334
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Patching configure.in file to make configure compile on Mac OS.
  # Patch taken from MacPorts.
  patch :DATA

  def install
    system "./run_autotools"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
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
