require 'formula'

class Libvpx <Formula
  url 'http://webm.googlecode.com/files/libvpx-v0.9.2.tar.bz2'
  sha1 'd3b386773aa11e2385829c078d52b3a3982d1122'
  homepage 'http://www.webmproject.org/code/'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
