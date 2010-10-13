require 'formula'

class Libexosip <Formula
  url 'http://www.very-clever.com/download/nongnu/exosip/libeXosip2-3.3.0.tar.gz'
  homepage 'http://www.antisip.com/as/'
  md5 'a2739067b51c1e417c5aef9606b285b2'

  depends_on 'pkg-config' => :build
  depends_on 'libosip'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
