require 'formula'

class Libfixbuf < Formula
  homepage 'http://tools.netsa.cert.org/fixbuf/'
  url 'http://tools.netsa.cert.org/releases/libfixbuf-1.1.1.tar.gz'
  md5 '92f4a743a79fb2b0b36b8c3a6cbe4238'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
