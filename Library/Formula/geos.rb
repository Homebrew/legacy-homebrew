require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.3.0.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 '3301f3d1d747b95749384b8a356b022a'

  def skip_clean? path
    path.extname == '.la'
  end

  fails_with_llvm "Some symbols are missing during link step."

  def install
    ENV.O3
    # Force GCC 4.2 instead of LLVM-GCC on Lion, per MacPorts:
    # https://trac.macports.org/ticket/30309
    ENV.gcc_4_2 if MacOS.lion?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
