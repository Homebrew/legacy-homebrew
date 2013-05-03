require 'formula'

class Geos < Formula
  homepage 'http://trac.osgeo.org/geos'
  url 'http://download.osgeo.org/geos/geos-3.3.8.tar.bz2'
  sha1 '1743e09f37eb75d85283a684a5765c4f44d035fa'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    # fixes compile error: missing symbols being optimized out using llvm.
    if ENV.compiler == :llvm then
      inreplace 'src/geom/Makefile.in', 'CFLAGS = @CFLAGS@', 'CFLAGS = @CFLAGS@ -O1'
      inreplace 'src/geom/Makefile.in', 'CXXFLAGS = @CXXFLAGS@', 'CXXFLAGS = @CXXFLAGS@ -O1'
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
