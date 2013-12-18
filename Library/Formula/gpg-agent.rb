require 'formula'

class GpgAgent < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.22.tar.bz2'
  sha1 '9ba9ee288e9bf813e0f1e25cbe06b58d3072d8b8'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pth'
  depends_on 'pinentry'

  # Adjust package name to fit our scheme of packaging both
  # gnupg 1.x and 2.x, and gpg-agent separately
  def patches; DATA; end

  def install
    # so we don't use Clang's internal stdint.h
    ENV['gl_cv_absolute_stdint_h'] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-agent-only",
                          "--with-pinentry-pgm=#{Formula.factory('pinentry').opt_prefix}/bin/pinentry",
                          "--with-scdaemon-pgm=#{Formula.factory('gnupg2').opt_prefix}/libexec/scdaemon"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index e5479af..782299d 100755
--- a/configure
+++ b/configure
@@ -578,8 +578,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gpg-agent'
+PACKAGE_TARNAME='gpg-agent'
 PACKAGE_VERSION='2.0.22'
 PACKAGE_STRING='gnupg 2.0.22'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'
