require 'formula'

class Log4cpp < Formula
  homepage 'http://log4cpp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.1.tar.gz'
  sha1 '23aa5bd7d6f79992c92bad3e1c6d64a34f8fcf68'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
