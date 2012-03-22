require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.74.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 '345358259ec4e58b5986b5d6fa8f82dfe2816c37'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
