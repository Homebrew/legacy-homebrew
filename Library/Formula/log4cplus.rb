require 'formula'

class Log4cplus < Formula
  homepage 'http://log4cplus.sourceforge.net/'
  url 'http://sourceforge.net/projects/log4cplus/files/log4cplus-stable/1.1.0/log4cplus-1.1.0.tar.bz2'
  sha1 '39482acb8b8c2dba2a6f4c81cb15b42cd78099aa'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
