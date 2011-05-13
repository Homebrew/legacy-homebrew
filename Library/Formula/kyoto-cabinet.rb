require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.53.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 'd32fe96dcee3156b15aba3bef8ea83d5969100d8'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
