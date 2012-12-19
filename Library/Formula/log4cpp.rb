require 'formula'

class Log4cpp < Formula
  homepage 'http://log4cpp.sourceforge.net/'
  url 'http://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.tar.gz'
  sha1 '6003105dd11b1fe6f0f88b5bc42c86cccd78d5ae'

  devel do
    url 'http://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1rc3.tar.gz'
    sha1 '24dc2eda5b1cee7af58a42924f61cd44c88f066a'
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
