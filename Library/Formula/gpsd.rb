require 'formula'

class Gpsd < Formula
  homepage 'https://savannah.nongnu.org/projects/gpsd'
  url 'http://download.savannah.gnu.org/releases/gpsd/gpsd-3.7.tar.gz'
  sha1 '6e9ae7c1117102de4f96193a2fdd2778d87af045'

  depends_on 'scons' => :build
  depends_on 'libusb' => :optional

  def install
    system "scons", "chrpath=False", "python=False", "strip=False", "shared=False",
                    "prefix=#{prefix}/"
    system "scons install"
  end
end
