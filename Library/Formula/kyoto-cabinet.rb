require 'formula'

class KyotoCabinet <Formula
  url 'http://1978th.net/kyotocabinet/kyotocabinet-1.0.0.tar.gz'
  homepage 'http://1978th.net/kyotocabinet/'
  md5 'b655bf60a16be81019362fe26fff9a6f'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
