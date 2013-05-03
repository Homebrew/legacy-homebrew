require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz'
  sha256 'ea1aebe282319537fb2d4d7805f478dd4e0e05c33d0928baba76a7c963684872'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--disable-lzma"
    system "make install"
  end
end
