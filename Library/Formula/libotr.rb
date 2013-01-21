require 'formula'

class Libotr < Formula
  homepage 'http://www.cypherpunks.ca/otr/'
  url 'http://www.cypherpunks.ca/otr/libotr-4.0.0.tar.gz'
  sha1 '8865e9011b8674290837afcf7caf90c492ae09cc'

  depends_on 'libgcrypt'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}"
    system "make install"
  end
end
