require 'formula'

class Aria2 < Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.10.9/aria2-1.10.9.tar.bz2'
  md5 '856cd88e75c7b893b42f4b6b8f2c0ad1'
  homepage 'http://aria2.sourceforge.net/'

  fails_with_llvm "1.8.2 didn't work w/ LLVM"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
