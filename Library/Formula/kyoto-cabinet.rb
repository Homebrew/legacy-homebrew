require 'formula'

class KyotoCabinet <Formula
  url 'http://fallabs.com/kyotocabinet/kyotocabinet-1.2.4.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 'ad52225ad2e28609e77accb68435a71c'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
