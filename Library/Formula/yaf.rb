require 'formula'

class Yaf < Formula
  homepage 'http://tools.netsa.cert.org/yaf/'
  url 'http://tools.netsa.cert.org/releases/yaf-2.4.0.tar.gz'
  sha1 '0c5efb5543e61d0acd91b7e2b028d8f6d3497ae8'

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
