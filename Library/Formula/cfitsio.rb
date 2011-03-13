require 'formula'

class Cfitsio < Formula
  url 'ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3240.tar.gz'
  homepage 'http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html'
  md5 'ba34e71562ed381a238678daffb116fb'
  version '3.24'

  def install
    # --disable-debug and --disable-dependency-tracking are not recognized by configure
    system "./configure", "--prefix=#{prefix}"
    system "make shared"
    system "make install"
  end
end
