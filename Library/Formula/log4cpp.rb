require 'formula'

class Log4cpp < Formula
  homepage 'http://log4cpp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20(new)/log4cpp-1.1/log4cpp-1.1.tar.gz'
  sha1 '6003105dd11b1fe6f0f88b5bc42c86cccd78d5ae'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
