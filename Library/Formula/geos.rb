require 'formula'

class Geos < Formula
  homepage 'http://trac.osgeo.org/geos'
  url 'http://download.osgeo.org/geos/geos-3.3.5.tar.bz2'
  sha1 '791e2b36a9a6114c7f213fae3fc995960c35a428'

  def install
    # fixes compile error: missing symbols being optimized out using llvm.
    if ENV.compiler == :llvm then
      inreplace 'src/geom/Makefile.in', 'CFLAGS = @CFLAGS@', 'CFLAGS = @CFLAGS@ -O1'
      inreplace 'src/geom/Makefile.in', 'CXXFLAGS = @CXXFLAGS@', 'CXXFLAGS = @CXXFLAGS@ -O1'
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
