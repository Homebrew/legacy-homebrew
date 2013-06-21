require 'formula'

class Gpsd < Formula
  homepage 'http://catb.org/gpsd/'
  url 'http://download.savannah.gnu.org/releases/gpsd/gpsd-3.9.tar.gz'
  sha1 'ff1db303000910d7cb7bfc3a75c97a0800df0f1b'

  depends_on 'scons' => :build
  depends_on 'libusb' => :optional

  def install
    system "scons", "chrpath=False", "python=False", "strip=False", "shared=False",
                    "prefix=#{prefix}/"
    system "scons install"
  end
end
