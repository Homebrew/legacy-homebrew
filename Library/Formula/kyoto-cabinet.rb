require 'formula'

class KyotoCabinet < Formula
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.72.tar.gz'
  homepage 'http://fallabs.com/kyotocabinet/'
  sha1 '3ce2a2b2f8f8d36aa6dea840f62f88342fcd2a3a'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
