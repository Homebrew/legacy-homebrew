require 'brewkit'

class Ccache <Formula
  @url='http://samba.org/ftp/ccache/ccache-2.4.tar.gz'
  @homepage='http://ccache.samba.org/'
  @md5='73c1ed1e767c1752dd0f548ec1e66ce7'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
