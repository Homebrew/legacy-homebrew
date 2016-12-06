require 'formula'

class Freetype2 <Formula
  url 'http://sourceforge.net/projects/freetype/files/freetype2/2.4.4/freetype-2.4.4.tar.gz/download'
  homepage 'http://freetype.sourceforge.net/index2.html'
  md5 '9273efacffb683483e58a9e113efae9f'
  version '2.4.4'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
