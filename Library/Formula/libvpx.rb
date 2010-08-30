require 'formula'

class Libvpx <Formula
  url 'http://webm.googlecode.com/files/libvpx-0.9.1.tar.bz2'
  sha1 'a18acb7a1a2fd62268e63aab860b43ff04669b9e'
  homepage 'http://www.webmproject.org/code/'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
