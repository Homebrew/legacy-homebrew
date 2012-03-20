require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'http://download.osgeo.org/libtiff/tiff-3.9.5.zip'
  sha256 '332d1a658340c41791fce62fb8fff2a5ba04c2e82b8b85e741eb0a7b30e0d127'

  def options
    [["--universal", "Builds a universal binary"]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-apple-opengl-framework"
    system "make install"
  end
end
