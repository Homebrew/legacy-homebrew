require 'formula'

class Mtools < Formula
  url 'ftp://ftpmirror.gnu.org/mtools/mtools-4.0.17.tar.gz'
  mirror 'ftp://ftp.gnu.org/gnu/mtools/mtools-4.0.17.tar.gz'
  homepage 'http://www.gnu.org/software/mtools/'
  md5 '231741ac95802d03aa32f44edb768171'

  def install
    system "./configure", "LIBS=-liconv", "--disable-debug",
                          "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
