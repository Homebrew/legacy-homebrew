require 'formula'

class KyotoCabinet <Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.21.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 'ed0a07db76dada68117e75d3181c884e'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
