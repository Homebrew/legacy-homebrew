class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://www.linuxfoundation.org/en/Accessibility/ATK/AT-SPI/AT-SPI_on_D-Bus"
  url "https://download.gnome.org/sources/at-spi2-atk/2.19/at-spi2-atk-2.19.91.tar.xz"
  sha256 "d8349f72795df0992e19a7717d87d4a028ca19ede1e1034782d2d7bd8f541289"

  bottle do
    cellar :any
    sha256 "a88de6d29ff859aa289347be7451348642dcd41b986362a1eb65c323443146fd" => :el_capitan
    sha256 "622fb5001ed08bddb08e92a00b45f0ca2a9f0f555eb8605bfe3cb1525bb5239f" => :yosemite
    sha256 "345365f5404530d5b28710325bb412338af39671b967a39b1afff91d63f9e315" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "at-spi2-core"
  depends_on "atk"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
