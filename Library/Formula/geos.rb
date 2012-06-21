require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.3.4.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  sha1 '2ec4be729c851460daf89d0d2ab785be5ef4c5c5'

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
