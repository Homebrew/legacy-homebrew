require 'formula'

class Yaf < Formula
  homepage 'http://tools.netsa.cert.org/yaf/'
  url 'http://tools.netsa.cert.org/releases/yaf-2.2.2.tar.gz'
  sha1 '03ea518d322d3ce76f312a71e5e444eb5a6a7273'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libfixbuf'

  def install
    system './configure', "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
