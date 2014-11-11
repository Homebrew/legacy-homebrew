require "formula"

class Bip < Formula
  homepage "http://bip.milkypond.org"
  url "http://ftp.de.debian.org/debian/pool/main/b/bip/bip_0.8.9.orig.tar.gz"
  sha1 "6c6828dde0ec9c41237bac42a679aa8237bdeffe"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
