require 'formula'

class Xdelta < Formula
  homepage 'http://xdelta.org'
  url 'http://xdelta.googlecode.com/files/xdelta3-3.0.5.tar.gz'
  sha1 'd760319a0484aa1b74a71fe6066a25eeabe7532a'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
