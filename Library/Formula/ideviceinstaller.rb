require 'formula'

class Ideviceinstaller < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'http://www.libimobiledevice.org/downloads/ideviceinstaller-1.0.1.tar.bz2'
  md5 '749b2062e86a00c0903ca8d5f0acabc6'

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'automake' => :build
  depends_on 'libimobiledevice'
  depends_on 'libzip'

  def install
    system 'autoreconf -ivf'
    system './configure', '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}"
    system 'make install'
  end

  def test
    system 'ideviceinstaller --help |grep -q ^Usage'
  end
end
