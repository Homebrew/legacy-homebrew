require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.3.1.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  sha1 '4f89e62c636dbf3e5d7e1bfcd6d9a7bff1bcfa60'

  def skip_clean? path
    path.extname == '.la'
  end

  fails_with_llvm "Some symbols are missing during link step."

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
