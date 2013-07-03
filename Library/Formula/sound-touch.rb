require 'formula'

class SoundTouch < Formula
  homepage 'http://www.surina.net/soundtouch/'
  url 'http://www.surina.net/soundtouch/soundtouch-1.7.1.tar.gz'
  sha256 '385eafa438a9d31ddf84b8d2f713097a3f1fc93d7abdb2fc54c484b777ee0267'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  # Fix autoreconf error
  def patches
    DATA
  end

  def install
    # SoundTouch has a small amount of inline assembly. The assembly has two labeled
    # jumps. When compiling with gcc optimizations the inline assembly is duplicated
    # and the symbol label occurs twice causing the build to fail.
    ENV.no_optimization
    # 64bit causes soundstretch to segfault when ever it is run.
    ENV.m32

    # The tarball doesn't contain a configure script, so we have to bootstrap.
    system "/bin/sh bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

__END__
--- soundtouch/configure.ac
+++ soundtouch/configure.ac
@@ -21,7 +21,7 @@

 AC_INIT(SoundTouch, 1.7.0, [http://www.surina.net/soundtouch])
 AC_CONFIG_AUX_DIR(config)
-AM_CONFIG_HEADER([include/soundtouch_config.h])
+AC_CONFIG_HEADER([include/soundtouch_config.h])
 AM_INIT_AUTOMAKE
 #AC_DISABLE_SHARED	dnl This makes libtool only build static libs
 AC_DISABLE_STATIC	dnl This makes libtool only build shared libs
