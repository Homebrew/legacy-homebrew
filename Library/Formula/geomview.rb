require 'formula'

class Geomview < Formula
  homepage 'http://www.geomview.org'
  url 'http://sourceforge.net/projects/geomview/files/geomview/1.9.4/geomview-1.9.4.tar.gz'
  sha1 'b5e04dfee5cef46655766c2456199905832cd45c'

  depends_on :x11
  depends_on 'lesstif'

  # Per MacPorts: https://trac.macports.org/ticket/35856
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/bin/animate/glob.c b/src/bin/animate/glob.c
index f573f9c..2d80834 100644
--- a/src/bin/animate/glob.c
+++ b/src/bin/animate/glob.c
@@ -41,7 +41,7 @@ static char sccsid[] = "@(#)glob.c    5.7 (Berkeley) 12/14/88";
 #include <errno.h>
 #include <pwd.h>

-#if !defined(dirfd) && !defined(__GLIBC__) && !defined(__linux__) && !defined(__FreeBSD__) && !defined(__CYGWIN__)
+#if !defined(dirfd) && !defined(__APPLE__) && !defined(__GLIBC__) && !defined(__linux__) && !defined(__FreeBSD__) && !defined(__CYGWIN__)
 #define dirfd(dirp)  ((dirp)->dd_fd)
 #endif
