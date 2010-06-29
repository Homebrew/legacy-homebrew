require 'formula'

class Sdcc <Formula
  url 'http://downloads.sourceforge.net/project/sdcc/sdcc/2.9.0/sdcc-src-2.9.0.tar.bz2'
  homepage 'http://sdcc.sourceforge.net/'
  md5 'a6151ed328fd3bc48305ffbc628dc122'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
