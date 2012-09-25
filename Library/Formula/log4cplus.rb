require 'formula'

class Log4cplus < Formula
  url 'http://sourceforge.net/projects/log4cplus/files/log4cplus-stable/1.0.4/log4cplus-1.0.4.tar.bz2'
  homepage 'http://log4cplus.sourceforge.net/'
  sha1 'b8ca1b01b23788ac04f25a7bdaaaca7e366c7312'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
