require 'formula'

class Cfitsio < Formula
  url 'ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3270.tar.gz'
  homepage 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html'
  md5 '2a72b323de3f40ad1a671f2167500336'
  version '3.27'

  def install
    # --disable-debug and --disable-dependency-tracking are not recognized by configure
    system "./configure", "--prefix=#{prefix}"
    system "make shared"
    system "make install"
  end
end
