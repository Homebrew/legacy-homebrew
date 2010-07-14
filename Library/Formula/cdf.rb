require 'formula'

class Cdf <Formula
  url 'http://download.berlios.de/bmp-plugins/cdf-0.2.tar.gz'
  homepage 'http://bmp-plugins.berlios.de/misc/cdf/cdf.html'
  md5 '1afd130f6c562700e8ad05724c6e1a9d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
