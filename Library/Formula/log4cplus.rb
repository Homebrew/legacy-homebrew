require 'formula'

class Log4cplus < Formula
  url 'http://sourceforge.net/projects/log4cplus/files/log4cplus-stable/1.0.4/log4cplus-1.0.4.tar.bz2'
  homepage 'http://log4cplus.sourceforge.net/'
  md5 '977d0a390b3be1a4ad8cfab2e4dd3af3'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
