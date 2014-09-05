require 'formula'

class Net6 < Formula
  homepage 'http://gobby.0x539.de'
  url 'http://releases.0x539.de/net6/net6-1.3.14.tar.gz'
  sha1 '7523a604e6b7f723cdd7f457f8f7c8c9cf48dae1'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'
  depends_on 'libsigc++'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
