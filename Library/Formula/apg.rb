require 'formula'

class Apg < Formula
  homepage 'http://www.adel.nursat.kz/apg/'
  url 'http://www.adel.nursat.kz/apg/download/apg-2.2.3.tar.gz'
  md5 '3b3fc4f11e90635519fe627c1137c9ac'

  def install
    system "make", "standalone",
                   "CC=#{ENV.cc}",
                   "FLAGS=#{ENV.cflags}",
                   "LIBS=", "LIBM="

    bin.install 'apg', 'apgbfm'
    man1.install 'doc/man/apg.1', 'doc/man/apgbfm.1'
  end
end
