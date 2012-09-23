require 'formula'

class Libfixbuf < Formula
  homepage 'http://tools.netsa.cert.org/fixbuf/'
  url 'http://tools.netsa.cert.org/releases/libfixbuf-1.1.1.tar.gz'
  sha1 'e88b4b5659ccba928589d49e0271820966da7f1f'

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
