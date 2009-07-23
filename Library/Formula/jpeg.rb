require 'brewkit'

class Jpeg <Formula
  @url='http://www.ijg.org/files/jpegsrc.v7.tar.gz'
  @md5='382ef33b339c299b56baf1296cda9785'
  @homepage='http://www.ijg.org'

  def install
    system "./configure --disable-debug --prefix='#{prefix}'"
    system "make install"
  end
end