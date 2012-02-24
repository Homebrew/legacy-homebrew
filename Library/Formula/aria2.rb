require 'formula'

class Aria2 < Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.14.1/aria2-1.14.1.tar.bz2'
  md5 '3a23844ab3e1460eb7e6dac9b5dd798c'

  homepage 'http://aria2.sourceforge.net/'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
