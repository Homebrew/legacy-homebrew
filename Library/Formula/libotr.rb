require 'formula'

class Libotr < Formula
  homepage 'https://otr.cypherpunks.ca/'
  url 'https://otr.cypherpunks.ca/libotr-4.1.0.tar.gz'
  sha1 'df30bc87a7a8f37678dd679d17fa1f9638ea247e'

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
