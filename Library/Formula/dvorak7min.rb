class Dvorak7min < Formula
  desc "Dvorak (simplified keyboard layout) typing tutor"
  homepage "http://dvorak7min.sourcearchive.com/"
  url "http://ftp.de.debian.org/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  sha1 "d4d2d300d6c6dc037f4411cccfe9bb237d26d178"
  version "1.6.1"

  bottle do
    cellar :any
    sha1 "3fa9330cc362cdf2e1141fdc334087c98fe4bce1" => :yosemite
    sha1 "245f20ef29453e0a269beee466b1d18b23ddcfc4" => :mavericks
    sha1 "f4654d6ad3c11702c98b9343fbed51d6a9eba401" => :mountain_lion
  end

  def install
    # Remove pre-built ELF binary first
    system "make", "clean"
    system "make"
    system "make", "INSTALL=#{bin}", "install"
  end
end
