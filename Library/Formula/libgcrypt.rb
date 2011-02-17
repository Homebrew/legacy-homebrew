require 'formula'

class Libgcrypt <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.4.6.tar.bz2'
  sha1 '445b9e158aaf91e24eae3d1040c6213e9d9f5ba6'
  homepage 'http://directory.fsf.org/project/libgcrypt/'

  depends_on 'libgpg-error'

  def install
    ENV.universal_binary	# build fat so wine can use it

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{HOMEBREW_PREFIX}"
    # Separate steps, or parallel builds fail
    system "make"
    system "make install"
  end
end
