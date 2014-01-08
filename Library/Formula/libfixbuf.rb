require 'formula'

class Libfixbuf < Formula
  homepage 'http://tools.netsa.cert.org/fixbuf/'
  url 'http://tools.netsa.cert.org/releases/libfixbuf-1.4.0.tar.gz'
  sha1 'cafb865c02ab78ef86f10153b1ff671fbe7d375a'

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
