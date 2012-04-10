require 'formula'

class Rand < Formula
  homepage 'http://www.elfga.com/~erik/'
  url 'http://www.elfga.com/~erik/files/rand-1.8.tar.bz2'
  md5 'b05fb52321811a4d120faa297ee1e375'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  def test
    system "/bin/ls | #{prefix}/bin/rand"
  end

end
