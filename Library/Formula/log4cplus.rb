require 'formula'

class Log4cplus < Formula
  url 'http://sourceforge.net/projects/log4cplus/files/log4cplus-stable/1.0.4/log4cplus-1.0.4.3.tar.bz2'
  homepage 'http://log4cplus.sourceforge.net/'
  sha1 '917d244f7f3d58a5fff35e3eef7fff9c74e9409b'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
