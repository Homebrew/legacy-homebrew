require "formula"

class SilcClient < Formula
  homepage "http://silcnet.org/software/users/client/"
  url "https://downloads.sourceforge.net/project/silc/silc/client/sources/silc-client-1.1.11.tar.gz"
  sha1 "e4438c87342edc95efdf67ac1a6dff9f0c70ea38"

  depends_on "pkg-config" => :build
  depends_on "glib"

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
