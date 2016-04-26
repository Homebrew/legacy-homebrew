class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "http://download.savannah.gnu.org/releases/gpsd/gpsd-3.16.tar.gz"
  sha256 "03579af13a4d3fe0c5b79fa44b5f75c9f3cac6749357f1d99ce5d38c09bc2029"

  bottle do
    cellar :any
    sha256 "67983abcb7de346346850eaaa3e007e2eb5bb25eb2e7fbc275a72781966892b0" => :el_capitan
    sha256 "676e8b9d1bddafc02863e1bdc64262ae09ec8a63e4fc3c1abdd930e6eeb28ee3" => :yosemite
    sha256 "843afd054bb63bc058173cd8a9bfbe529e01e331ae3680bb170406204b16f889" => :mavericks
  end

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  def install
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end
end
