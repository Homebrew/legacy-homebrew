require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.58.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 'e14b24c43cd102a9f881e2c26a94871e7df0facf'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
