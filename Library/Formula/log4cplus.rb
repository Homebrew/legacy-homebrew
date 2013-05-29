require 'formula'

class Log4cplus < Formula
  homepage 'http://log4cplus.sourceforge.net/'
  url 'http://sourceforge.net/projects/log4cplus/files/log4cplus-stable/1.1.1/log4cplus-1.1.1.tar.bz2'
  sha1 '3a86b2e124091c9345ee1bac81ca1fb3773fad60'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
