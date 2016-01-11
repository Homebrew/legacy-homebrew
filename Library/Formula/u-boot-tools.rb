class UBootTools < Formula
  desc "Universal boot loader"
  homepage "http://www.denx.de/wiki/U-Boot/"
  url "ftp://ftp.denx.de/pub/u-boot/u-boot-2015.01.tar.bz2"
  sha256 "383051a656ebe11757b17d38a3326387e4a1b0949ca8a9e8ee506bf71dac9fde"

  bottle do
    cellar :any
    sha256 "4c369426945ddde9ec41b7b85108dce2f8dd0dd70a2fb7a308e2175f76efa55f" => :yosemite
    sha256 "4268ed8923b3fe1f2d3e2dc87db23104a8b578636d86c47bf0ea25daae1c03ea" => :mavericks
    sha256 "9756327207b93d3b3cd1c00365f5059ab16f2c3c2baffbfde5e8b918d85483bd" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "make", "sandbox_defconfig"
    system "make", "tools"
    bin.install "tools/mkimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
  end
end
