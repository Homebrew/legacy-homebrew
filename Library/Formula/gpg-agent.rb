require 'formula'

class GpgAgent < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.18.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '5ec2f718760cc3121970a140aeea004b64545c46'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pth'
  depends_on 'pinentry'

  def patches
    DATA # fix package name to avoid conflicts
  end

  def install
    # so we don't use Clang's internal stdint.h
    ENV['gl_cv_absolute_stdint_h'] = '/usr/include/stdint.h'

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-agent-only"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 3df3900..b102aec 100755
--- a/configure
+++ b/configure
@@ -558,8 +558,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gpg-agent'
+PACKAGE_TARNAME='gpg-agent'
 PACKAGE_VERSION='2.0.18'
 PACKAGE_STRING='gnupg 2.0.18'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'
