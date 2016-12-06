require 'formula'

class Nano < Formula
  homepage 'http://www.nano-editor.org/'
  url 'http://www.nano-editor.org/dist/v2.2/nano-2.2.6.tar.gz'
  md5 '03233ae480689a008eb98feb1b599807'
  
  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
  
  def test
    system "#{prefix}/nano --version"
  end
end
