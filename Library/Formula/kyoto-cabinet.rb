require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.51.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 '220d8896cac4917ad839810eddfbe18b'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
