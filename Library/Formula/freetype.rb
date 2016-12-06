require 'formula'

class Freetype <Formula
  url 'http://download.savannah.gnu.org/releases/freetype/freetype-2.4.4.tar.bz2'
  homepage 'http://freetype.org/'
  md5 'b3e2b6e2f1c3e0dffa1fd2a0f848b671'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
