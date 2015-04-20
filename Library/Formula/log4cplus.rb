require 'formula'

class Log4cplus < Formula
  homepage 'http://log4cplus.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/1.1.2/log4cplus-1.1.2.tar.bz2'
  sha1 '39caf65f9aaaed3698dcc239a2fa26f1f90952c9'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
