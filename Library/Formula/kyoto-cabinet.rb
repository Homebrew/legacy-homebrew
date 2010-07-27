require 'formula'

class KyotoCabinet <Formula
  url 'http://1978th.net/kyotocabinet/kyotocabinet-1.2.0.tar.gz'
  homepage 'http://1978th.net/kyotocabinet/'
  md5 'c690b932afdb7c0c6051c180d6307f3d'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
