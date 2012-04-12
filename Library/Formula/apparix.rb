require 'formula'

class Apparix < Formula
  url 'http://micans.org/apparix/src/apparix-11-062.tar.gz'
  homepage 'http://micans.org/apparix/'
  md5 'c3c359312295be2a68726c826c112186'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
