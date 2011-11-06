require 'formula'

class Aria2 < Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.12.1/aria2-1.12.1.tar.bz2'
  md5 '9f3bf96d92bc8b70b74817ed10c2c7e7'
  homepage 'http://aria2.sourceforge.net/'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
