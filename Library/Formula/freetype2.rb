require 'formula'

class Freetype2 <Formula
  url 'http://download.savannah.gnu.org/releases/freetype/freetype-2.4.4.tar.bz2'
  homepage 'http://savannah.nongnu.org/projects/freetype'
  md5 'b3e2b6e2f1c3e0dffa1fd2a0f848b671'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
