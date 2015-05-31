class Flashrom < Formula
  homepage "http://flashrom.org/"
  url "http://download.flashrom.org/releases/flashrom-0.9.8.tar.bz2"
  sha256 "13dc7c895e583111ecca370363a3527d237d178a134a94b20db7df177c05f934"

  head "svn://flashrom.org/flashrom/trunk"

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
