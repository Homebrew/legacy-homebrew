require 'formula'

class Ideviceinstaller < Formula
  url 'git://git.sukimashita.com/ideviceinstaller.git'
  homepage 'http://cgit.sukimashita.com/ideviceinstaller.git/'
  version '1.0.1'

  depends_on 'libimobiledevice'
  depends_on 'libzip'

  def install
    system "./autogen.sh",  "--prefix=#{prefix}"
    system "make install"
  end
end
