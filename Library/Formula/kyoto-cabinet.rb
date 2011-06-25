require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.63.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 'c614e87828934298eaf68055a9eabdc62a17aed5'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
