class Kbtin < Formula
  desc "Heavily extended clone of TinTin++"
  homepage "http://kbtin.sourceforge.net"
  url "https://downloads.sourceforge.net/project/kbtin/kbtin/1.0.14/kbtin-1.0.14.tar.xz"
  sha256 "7b495e04d894f5958336756055800cec148ae5a7336c0a2b26dd2084c37d1f5c"
  revision 1

  depends_on "gnutls"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
