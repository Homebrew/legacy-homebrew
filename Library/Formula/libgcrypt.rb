require 'formula'

class Libgcrypt < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.5.0.tar.bz2'
  sha1 '3e776d44375dc1a710560b98ae8437d5da6e32cf'
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
    system "make check"
    system "make install"
  end
end
