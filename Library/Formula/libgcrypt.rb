require 'formula'

class Libgcrypt <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.4.5.tar.bz2'
  sha1 'ef7ecbd3a03a7978094366bcd1257b3654608d28'
  homepage 'http://directory.fsf.org/project/libgcrypt/'

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{HOMEBREW_PREFIX}"
    # Separate steps, or parallel builds fail
    system "make"
    system "make install"
  end
end
