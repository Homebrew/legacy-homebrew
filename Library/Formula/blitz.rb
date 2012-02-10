require 'formula'

class Blitz < Formula
  homepage 'http://oonumerics.org/blitz'
  url 'http://downloads.sourceforge.net/project/blitz/blitz/Blitz%2B%2B%200.9/blitz-0.9.tar.gz'
  md5 '031df2816c73e2d3bd6d667bbac19eca'

  head 'http://blitz.hg.sourceforge.net:8000/hgroot/blitz/blitz', :using => :hg

  def install
    system "/usr/bin/autoreconf", "-fi" if ARGV.build_head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--infodir=#{info}",
                          "--enable-shared",
                          "--disable-doxygen",
                          "--disable-dot",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
