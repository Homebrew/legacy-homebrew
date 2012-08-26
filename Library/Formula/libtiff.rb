require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'http://download.osgeo.org/libtiff/tiff-4.0.2.tar.gz'
  sha256 'aa29f1f5bfe3f443c3eb4dac472ebde15adc8ff0464b83376f35e3b2fef935da'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--without-x",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
