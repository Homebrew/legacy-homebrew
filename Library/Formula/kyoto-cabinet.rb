require 'formula'

class KyotoCabinet <Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.43.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 '74f3c4307a57e22daa5251131925dd4e'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
