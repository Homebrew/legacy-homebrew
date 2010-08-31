require 'formula'

class Libtiff <Formula
  url 'http://download.osgeo.org/libtiff/tiff-3.9.2.tar.gz'
  homepage 'http://www.remotesensing.org/libtiff/'
  md5 '93e56e421679c591de7552db13384cb8'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
