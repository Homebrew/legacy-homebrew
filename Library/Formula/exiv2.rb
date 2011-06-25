require 'formula'

class Exiv2 < Formula
  url 'http://www.exiv2.org/exiv2-0.20.tar.gz'
  homepage 'http://www.exiv2.org'
  md5 '3173d08a4313dc94b7bd1b7cdbda2093'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
