require 'formula'

class Cfitsio < Formula
  url 'ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3280.tar.gz'
  homepage 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html'
  md5 'fdb9c0f51678b47e78592c70fb5dc793'
  version '3.28'

  def install
    # --disable-debug and --disable-dependency-tracking are not recognized by configure
    system "./configure", "--prefix=#{prefix}"
    system "make shared"
    system "make install"
  end
end
