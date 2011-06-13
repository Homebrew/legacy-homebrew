require 'formula'

class Aria2 < Formula
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.11.1/aria2-1.11.1.tar.bz2'
  md5 'da785645a6d92450b0a54f384202ba6b'
  homepage 'http://aria2.sourceforge.net/'

  fails_with_llvm "1.8.2 didn't work w/ LLVM"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
