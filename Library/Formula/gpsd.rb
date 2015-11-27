class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "http://download.savannah.gnu.org/releases/gpsd/gpsd-3.15.tar.gz"
  sha256 "81c89e271ae112313e68655ab30d227bc38fe7841ffbff0f1860b12a9d7696ea"

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  def install
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end
end
