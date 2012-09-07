require 'formula'

class Scamper < Formula
  url 'http://www.wand.net.nz/scamper/scamper-cvs-20110217.tar.gz'
  homepage 'http://www.wand.net.nz/scamper/'
  sha1 '97e15ad73376ecef37f381e6e3d911584fe7ffba'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
