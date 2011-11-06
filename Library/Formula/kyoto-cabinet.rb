require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.70.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 '58dee8ff10dbff4d9508fdcfa8d5699ef1035f74'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
