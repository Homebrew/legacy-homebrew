require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.50.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 '71914aa2de12c1e924021eecc6a18a58'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
