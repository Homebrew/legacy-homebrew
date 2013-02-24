require 'formula'

class Apg < Formula
  homepage 'http://www.adel.nursat.kz/apg/'
  url 'http://www.adel.nursat.kz/apg/download/apg-2.2.3.tar.gz'
  sha1 '7bdbc931ef8477717186dc3ab3a2d3c25012b4ca'

  def install
    system "make", "standalone",
                   "CC=#{ENV.cc}",
                   "FLAGS=#{ENV.cflags}",
                   "LIBS=", "LIBM="

    bin.install 'apg', 'apgbfm'
    man1.install 'doc/man/apg.1', 'doc/man/apgbfm.1'
  end
end
