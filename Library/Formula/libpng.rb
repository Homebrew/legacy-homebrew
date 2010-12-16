require 'formula'

class Libpng <Formula
  url 'http://downloads.sourceforge.net/project/libpng/libpng12/1.2.44/libpng-1.2.44.tar.bz2'
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  md5 'e3ac7879d62ad166a6f0c7441390d12b'

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
