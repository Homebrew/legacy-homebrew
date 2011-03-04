require 'formula'

class KyotoCabinet <Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.47.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 '7a90ecb06d3c598568cfbc74021f7076'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
