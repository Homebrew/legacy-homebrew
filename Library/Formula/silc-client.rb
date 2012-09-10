require 'formula'

class SilcClient < Formula
  homepage 'http://silcnet.org/software/users/client/'
  url 'http://silcnet.org/download/client/sources/silc-client-1.1.8.tar.gz'
  sha1 '51fd1f22dbc1ceb15c6fb1a034eb9a09b72ee708'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-perl=no",
                          "--enable-ssl",
                          "--enable-ipv6",
                          "--with-socks",
                          "--disable-asm"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/silc", "-v"
  end
end
