require 'brewkit'

class Libpng <Formula
  @url='http://prdownloads.sourceforge.net/libpng/libpng-1.2.40.tar.gz'
  @homepage='http://www.libpng.org/pub/png/libpng.html'
  @md5='a2f6808735bf404967f81519a967fb2a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
