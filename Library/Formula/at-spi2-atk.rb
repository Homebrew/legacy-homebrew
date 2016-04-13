class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-atk/2.20/at-spi2-atk-2.20.1.tar.xz"
  sha256 "2358a794e918e8f47ce0c7370eee8fc8a6207ff1afe976ec9ff547a03277bf8e"

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
