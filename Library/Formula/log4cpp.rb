require 'formula'

class Log4cpp < Formula
  url 'http://downloads.sourceforge.net/project/log4cpp/log4cpp-1.0.x%20%28current%29/log4cpp-1.0/log4cpp-1.0.tar.gz'
  homepage 'http://log4cpp.sourceforge.net/'
  md5 '1face50ead0790d1297dfb04bacf273c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
