class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "http://flashrom.org/"
  url "http://download.flashrom.org/releases/flashrom-0.9.8.tar.bz2"
  sha256 "13dc7c895e583111ecca370363a3527d237d178a134a94b20db7df177c05f934"

  head "svn://flashrom.org/flashrom/trunk"

  bottle do
    cellar :any
    sha256 "aeaaed81630634b45ea99449245ddb8bd1effecaee062f0734ad72464f8f81aa" => :el_capitan
    sha256 "aedac2e61e6e5926a8a30207137d509d3f5c5661e2fdf89ae8200e78a5f095dc" => :yosemite
    sha256 "f5c2516a19df0fe6945a9536dad7a11f3de1c4f21de1890b916211ff2cabb70b" => :mavericks
    sha256 "bb314be2b1181ad6a4fb41ccabb92b4b72b49fa31c87a180cbe5af85eb56f322" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "libftdi0"

  def install
    ENV["CONFIG_GFXNVIDIA"] = "0"
    ENV["CONFIG_NIC3COM"] = "0"
    ENV["CONFIG_NICREALTEK"] = "0"
    ENV["CONFIG_NICNATSEMI"] = "0"
    ENV["CONFIG_NICINTEL"] = "0"
    ENV["CONFIG_NICINTEL_SPI"] = "0"
    ENV["CONFIG_NICINTEL_EEPROM"] = "0"
    ENV["CONFIG_OGP_SPI"] = "0"
    ENV["CONFIG_SATAMV"] = "0"
    ENV["CONFIG_SATASII"] = "0"
    ENV["CONFIG_DRKAISER"] = "0"
    ENV["CONFIG_RAYER_SPI"] = "0"
    ENV["CONFIG_INTERNAL"] = "0"
    ENV["CONFIG_IT8212"] = "0"
    ENV["CONFIG_ATAHPT"] = "0"
    ENV["CONFIG_ATAVIA"] = "0"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system "#{bin}/flashrom" " --version"
  end
end
