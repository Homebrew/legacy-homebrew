require 'formula'

class SilcClient < Formula
  homepage 'http://silcnet.org/software/users/client/'
  url 'https://downloads.sourceforge.net/project/silc/silc/client/sources/silc-client-1.1.10.tar.gz'
  sha1 '78c5ed2977c2dd4f3d9852e1ab09ba06a433feba'

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

  test do
    system "#{bin}/silc", "-v"
  end
end
