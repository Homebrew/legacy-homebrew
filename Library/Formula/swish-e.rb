require 'formula'

class SwishE < Formula
  url 'http://swish-e.org/distribution/swish-e-2.4.7.tar.gz'
  homepage 'http://swish-e.org/'
  sha1 '0970c5f8dcb2f12130b38a9fc7dd99c2f2d7ebcb'

  depends_on 'libxml2'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
