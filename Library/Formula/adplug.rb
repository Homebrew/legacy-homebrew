require 'formula'

class Adplug <Formula
  url 'http://downloads.sourceforge.net/project/adplug/AdPlug%20core%20library/2.2.1/adplug-2.2.1.tar.bz2'
  homepage 'http://adplug.sf.net'
  md5 '8f815fd5d254de0fe5df818df9d1d8af'

  depends_on 'pkg-config'
  depends_on 'libbinio'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
