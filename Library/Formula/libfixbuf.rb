require 'formula'

class Libfixbuf < Formula
  homepage 'http://tools.netsa.cert.org/fixbuf/'
  url 'http://tools.netsa.cert.org/releases/libfixbuf-1.2.0.tar.gz'
  sha1 'c05c832f5317b1e51fa178e58cd4e6ba914d567b'

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
