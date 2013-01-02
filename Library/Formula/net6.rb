require 'formula'

class Net6 < Formula
  homepage 'http://gobby.0x539.de'
  url 'http://releases.0x539.de/net6/net6-1.3.14.tar.gz'
  sha1 '7523a604e6b7f723cdd7f457f8f7c8c9cf48dae1'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'
  depends_on 'libsigc++'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    cflags = `pkg-config --cflags net6-1.3.pc` # for some reason, won't pick up sigc++ otherwise
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "libnet6_CFLAGS=#{cflags}" # and now we need a second pass to properly set the includes...yuck!
    system "make install"
  end
end
