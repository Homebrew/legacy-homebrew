require 'formula'

class Xdelta < Formula
  homepage 'http://xdelta.org'
  url 'http://xdelta.googlecode.com/files/xdelta3-3.0.6.tar.gz'
  sha1 'a468ce0efb0cd1c7dbdff637731e9ac6470437c6'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
