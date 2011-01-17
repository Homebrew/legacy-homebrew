require 'formula'

class KyotoCabinet <Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.34.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  md5 '47f074648e5c4cc619be7be3cb05c3b0'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
