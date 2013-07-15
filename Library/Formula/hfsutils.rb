require 'formula'

class Hfsutils < Formula
  homepage 'http://www.mars.org/home/rob/proj/hfs/'
  url 'ftp://ftp.mars.org/pub/hfs/hfsutils-3.2.6.tar.gz'
  sha1 '6d71dfb2c93c0d8082972d39f3f75ae53a438d5d'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    bin.mkpath
    man1.mkpath
    system "make install"
  end
end
