class Dvorak7min < Formula
  homepage "http://dvorak7min.sourcearchive.com/"
  url "http://ftp.de.debian.org/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  sha1 "d4d2d300d6c6dc037f4411cccfe9bb237d26d178"
  version "1.6.1"

  def install
    # Remove pre-built ELF binary first
    system "make", "clean"
    system "make"
    system "make", "INSTALL=#{bin}", "install"
  end
end
