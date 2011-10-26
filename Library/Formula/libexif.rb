require 'formula'

class Libexif < Formula
  url 'http://downloads.sourceforge.net/project/libexif/libexif/0.6.20/libexif-0.6.20.tar.bz2'
  homepage 'http://libexif.sourceforge.net/'
  md5 '19844ce6b5d075af16f0d45de1e8a6a3'

  fails_with_llvm "segfault with llvm", :build => 2334

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
