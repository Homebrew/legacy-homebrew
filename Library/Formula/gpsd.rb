class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "http://download.savannah.gnu.org/releases/gpsd/gpsd-3.16.tar.gz"
  sha256 "03579af13a4d3fe0c5b79fa44b5f75c9f3cac6749357f1d99ce5d38c09bc2029"

  bottle do
    cellar :any
    sha256 "3217799db940813d04dafecb52efd5b1a00ff8afd8245979728b82a9227c7269" => :el_capitan
    sha256 "ac0aa5f2d768a113587eb7cb5ce07bd268aeaaecde5fc60f39330bfdff54999d" => :yosemite
    sha256 "a2905cf71c569793fafb1d5c5000bd25851499d66c3b4ebea1ec2b241800834b" => :mavericks
  end

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  def install
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end
end
