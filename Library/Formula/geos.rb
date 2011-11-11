require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.3.1.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 'b1ceefe205c9ee520b99f2b072c345f7'

  def skip_clean? path
    path.extname == '.la'
  end

  fails_with_llvm "Some symbols are missing during link step."

  def install
    ENV.O3
    # Force CLang instead of LLVM-GCC on Lion:
    # http://trac.osgeo.org/geos/ticket/463
    ENV.clang if MacOS.lion?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
