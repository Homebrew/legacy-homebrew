require 'formula'

class Libpng <Formula
  url 'http://downloads.sourceforge.net/project/libpng/03-libpng-previous/1.2.43/libpng-1.2.43.tar.bz2'
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  md5 '976909556e6613804d810405c1f72ce6'

  def keg_only?
    :provided_by_osx
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
