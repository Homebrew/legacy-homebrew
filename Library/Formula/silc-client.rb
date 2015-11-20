class SilcClient < Formula
  desc "SILC conferencing client"
  homepage "http://silcnet.org/client.html"
  url "https://downloads.sourceforge.net/project/silc/silc/client/sources/silc-client-1.1.11.tar.gz"
  sha256 "8cedf2f3c15322296afe094de60504bc27e349f1942713a2f322c7ef6ad5089e"
  bottle do
    sha256 "53479f39d855351579b0511907cd9d3f68504e0443ed3d1ffa4fa1e7c8caf3c9" => :yosemite
    sha256 "6b7f1d475ae6a2b2e6c480a3cf99f25ec1e02c2d5c71349f2814240263844785" => :mavericks
    sha256 "6c89c1d50049ae283d04e954678ded56530e4da2fd2ac25b8b9ddb49f5eced8e" => :mountain_lion
  end

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
