require "formula"

class Flashrom < Formula
  homepage "http://flashrom.org/"
  url "http://download.flashrom.org/releases/flashrom-0.9.7.tar.bz2"
  sha1 "d08b4073ea3ebf63f03c3e502f4291f50ef348ee"

  head "svn://flashrom.org/flashrom/trunk"

  depends_on "libusb-compat"
  depends_on "libftdi0"

  def install
    ENV["CONFIG_GFXNVIDIA"] = "0"
    ENV["CONFIG_NIC3COM"] = "0"
    ENV["CONFIG_NICREALTEK"] = "0"
    ENV["CONFIG_NICINTEL"] = "0"
    ENV["CONFIG_NICINTEL_SPI"] = "0"
    ENV["CONFIG_OGP_SPI"] = "0"
    ENV["CONFIG_SATAMV"] = "0"
    ENV["CONFIG_SATASII"] = "0"
    ENV["CONFIG_DRKAISER"] = "0"
    ENV["CONFIG_RAYER_SPI"] = "0"
    ENV["CONFIG_INTERNAL"] = "0"

    system "make DESTDIR=#{prefix} PREFIX=/ install"
    mv sbin, bin
  end

  test do
    system "#{bin}/flashrom" " --version"
  end
end
