require 'formula'

class Log4cpp < Formula
  url 'http://downloads.sourceforge.net/project/log4cpp/log4cpp-1.0.x%20%28old%29/log4cpp-1.0/log4cpp-1.0.tar.gz'
  homepage 'http://log4cpp.sourceforge.net/'
  sha1 'bdb2fa7a8c8af738d79156bf9f6191875cdba5cc'

  devel do
    url 'http://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1rc3.tar.gz'
    sha1 '24dc2eda5b1cee7af58a42924f61cd44c88f066a'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
