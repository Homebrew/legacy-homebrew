require 'formula'

class Hfsutils < Formula
  url 'ftp://ftp.mars.org/pub/hfs/hfsutils-3.2.6.tar.gz'
  homepage 'http://www.mars.org/home/rob/proj/hfs/'
  md5 'fa572afd6da969e25c1455f728750ec4'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    bin.mkpath
    man1.mkpath
    system "make install"
  end
end
