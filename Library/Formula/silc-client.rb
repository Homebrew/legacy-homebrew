require "formula"

class SilcClient < Formula
  homepage "http://silcnet.org/client.html"
  url "https://downloads.sourceforge.net/project/silc/silc/client/sources/silc-client-1.1.11.tar.gz"
  sha256 "8cedf2f3c15322296afe094de60504bc27e349f1942713a2f322c7ef6ad5089e"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"

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
    system "make", "install"
  end

  test do
    system "#{bin}/silc", "-v"
  end
end
