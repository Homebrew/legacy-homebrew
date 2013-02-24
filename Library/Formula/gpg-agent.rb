require 'formula'

class GpgAgent < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.19.tar.bz2'
  sha1 '190c09e6688f688fb0a5cf884d01e240d957ac1f'

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
    ENV['gl_cv_absolute_stdint_h'] = '/usr/include/stdint.h'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-agent-only",
                          "--with-pinentry-pgm=#{HOMEBREW_PREFIX}/bin/pinentry"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 829fc79..684213e 100755
--- a/configure
+++ b/configure
@@ -558,8 +558,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gpg-agent'
+PACKAGE_TARNAME='gpg-agent'
 PACKAGE_VERSION='2.0.19'
 PACKAGE_STRING='gnupg 2.0.19'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'
