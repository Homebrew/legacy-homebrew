require 'formula'

class KyotoCabinet <Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.30.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 'cba58e553c5b8cc48c48552c56b15cf5'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
