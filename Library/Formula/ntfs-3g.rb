require 'formula'

class Ntfs3g < Formula
  url 'http://tuxera.com/opensource/ntfs-3g_ntfsprogs-2011.4.12.tgz'
  homepage 'http://www.tuxera.com/community/ntfs-3g-download/'
  md5 '9c4ce318373b15332239a77a9d2a39fe'

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def patches
    # From macports: trunk/dports/fuse/ntfs-3g/files/patch-configure.diff
    # Modify configure such that it does not modify the default PKG_CONFIG_PATH
    { :p0 => DATA }
  end

  def install
    # Workaround for hardcoded /sbin in ntfsprogs
    inreplace "ntfsprogs/Makefile.in", "/sbin", sbin

    ENV.append "LDFLAGS", "-lintl"
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--exec-prefix=#{prefix}",
            "--mandir=#{man}",
            "--disable-library",
            "--with-fuse=external"]
    system "./configure", *args
    system "make"

    system "make install"
  end

  def caveats
    <<-EOS.undent
    The default Mac OSX automounter is not replaced by this installation. Read
    http://fernandoff.posterous.com/ntfs-write-support-on-osx-lion-with-ntfs-3g-f
    for more infomation on how to replace the default automounter.

    Remember to install the fuse4x kernel extension as the root user.
    Instructions are found here: $(brew info fuse4x-kext).
    EOS
  end
end

__END__
--- configure.orig	2011-08-02 19:13:55.000000000 -0400
+++ configure	2011-08-02 19:14:14.000000000 -0400
@@ -20530,9 +20530,6 @@
	test "x${PKG_CONFIG}" = "xno" && { { echo "$as_me:$LINENO: error: pkg-config wasn't found! Please install from your vendor, or see http://pkg-config.freedesktop.org/wiki/" >&5
 echo "$as_me: error: pkg-config wasn't found! Please install from your vendor, or see http://pkg-config.freedesktop.org/wiki/" >&2;}
    { (exit 1); exit 1; }; }
-	# Libraries often install their metadata .pc files in directories
-	# not searched by pkg-config. Let's workaround this.
-	export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/lib/pkgconfig:/usr/lib/pkgconfig:/opt/gnome/lib/pkgconfig:/usr/share/pkgconfig:/usr/local/lib/pkgconfig:$prefix/lib/pkgconfig:/opt/gnome/share/pkgconfig:/usr/local/share/pkgconfig

 pkg_failed=no
 { echo "$as_me:$LINENO: checking for FUSE_MODULE" >&5
