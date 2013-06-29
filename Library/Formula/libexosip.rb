require 'formula'

class Libexosip < Formula
  homepage 'http://www.antisip.com/as/'
  url 'http://download.savannah.gnu.org/releases/exosip/libeXosip2-3.6.0.tar.gz'
  sha1 'a53d699208a22a4edf2d239e1dc3a2f4c1fee0d2'

  depends_on 'pkg-config' => :build
  depends_on 'libosip'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
