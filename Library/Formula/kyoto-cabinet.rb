require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.69.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 '93ae2c560f72221cef51d0cb8780eb9e90e9d621'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
