require 'formula'

class Gpsd < Formula
  homepage 'http://catb.org/gpsd/'
  url 'http://download.savannah.gnu.org/releases/gpsd/gpsd-3.9.tar.gz'
  sha1 'ff1db303000910d7cb7bfc3a75c97a0800df0f1b'

  depends_on 'scons' => :build
  depends_on 'libusb' => :optional

  patch :p0 do
    url "https://trac.macports.org/export/113474/trunk/dports/net/gpsd/files/string.patch"
    sha1 "7f6bacc0379282bf27b05d754807000680befb26"
  end

  def install
    scons "chrpath=False", "python=False", "strip=False", "shared=False", "prefix=#{prefix}/"
    scons "install"
  end
end
