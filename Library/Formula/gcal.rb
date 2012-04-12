require 'formula'

class Gcal < Formula
  url 'http://ftpmirror.gnu.org/gcal/gcal-3.6.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gcal/gcal-3.6.1.tar.gz'
  homepage 'http://www.gnu.org/software/gcal/'
  md5 'a89e96db054a8b23ff6cd97049527a4f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
