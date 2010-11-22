require 'formula'

class KyotoCabinet <Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.24.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 'bee226eadd99bef339c5a19c1d1f2953'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
