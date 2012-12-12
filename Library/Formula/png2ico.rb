require 'formula'

class Png2ico < Formula
  homepage 'http://www.winterdrache.de/freeware/png2ico/'
  url 'http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz'
  sha1 '955004bee9a20f12b225aa01895762cbbafaeb28'

  depends_on :libpng

  def install
    inreplace 'Makefile', 'g++', '$(CXX)'
    system "make", "CPPFLAGS=#{ENV.cxxflags} #{ENV.cppflags} #{ENV.ldflags}"
    bin.install 'png2ico'
    man1.install 'doc/png2ico.1'
  end
end
