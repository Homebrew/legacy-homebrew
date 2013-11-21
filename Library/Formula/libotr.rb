require 'formula'

class Libotr < Formula
  homepage 'http://www.cypherpunks.ca/otr/'
  url 'http://www.cypherpunks.ca/otr/libotr-3.2.1.tar.gz'
  sha1 '898bf00d019f49ca34cd0116dd2e22685c67c394'

  depends_on 'libgcrypt'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
