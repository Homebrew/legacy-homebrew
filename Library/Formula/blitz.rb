require 'formula'

class Blitz < Formula
  url 'http://downloads.sourceforge.net/project/blitz/blitz/Blitz%2B%2B%200.9/blitz-0.9.tar.gz'
  homepage 'http://oonumerics.org/blitz'
  md5 '031df2816c73e2d3bd6d667bbac19eca'
  version '0.9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--infodir=#{info}",
                          "--enable-shared",
                          "--disable-doxygen",
                          "--disable-dot",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
