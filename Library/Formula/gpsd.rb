class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "http://download.savannah.gnu.org/releases/gpsd/gpsd-3.9.tar.gz"
  sha256 "d9b24be838b48db5e8eba66f74edf32d1982fe0fb018c9d9a7ad1ada9f189d5a"

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  patch :p0 do
    url "https://trac.macports.org/export/113474/trunk/dports/net/gpsd/files/string.patch"
    sha256 "b3c4627cd75fd5869ab692e443bbcd0e8406e6d38f732ad43f1d9ed9952cf3c1"
  end

  def install
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end
end
