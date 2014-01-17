require 'formula'

class Sshfs < Formula
  homepage 'http://fuse.sourceforge.net/sshfs.html'
  url 'https://github.com/osxfuse/sshfs/archive/osxfuse-sshfs-2.4.1.tar.gz'
  sha1 'cf614508db850a719529dec845ae59309f8a79c2'

  def patches; DATA end

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'
  depends_on 'glib'
  depends_on :xcode

  def install
    # Compatibility with Automake 1.13 and newer.
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'

    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info osxfuse`
    before trying to use a FUSE-based filesystem.
    EOS
  end
end

__END__
diff -u a/sshfs.c b/sshfs.c
--- a/sshfs.c.orig	2014-01-16 17:03:38.000000000 -0500
+++ b/sshfs.c	2014-01-16 17:02:23.000000000 -0500
@@ -13,6 +13,7 @@
 #include <fuse_opt.h>
 #include <fuse_lowlevel.h>
 #ifdef __APPLE__
+#  define DARWIN_SEMAPHORE_COMPAT
 #  include <fuse_darwin.h>
 #endif
 #include <assert.h>
