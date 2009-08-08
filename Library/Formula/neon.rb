require 'brewkit'

class Neon <Formula
  @url='http://www.webdav.org/neon/neon-0.28.5.tar.gz'
  @homepage='http://www.webdav.org/neon/'
  @md5='8c160bc0e358a3b58645acbba40fe873'

  def install
    system "./configure --prefix='#{prefix}' --disable-debug --disable-dependency-tracking"
    system "make install"
  end
end
