require 'formula'

class Libxmi < Formula
  homepage 'http://www.gnu.org/software/libxmi/'
  url 'http://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz'
  mirror 'http://ftp.gnu.org/libxmi/libxmi-1.2.tar.gz'
  sha1 '62fa13ec4c8b706729c2553122e44f81715f3c0b'

  bottle do
    cellar :any
    sha1 "a78fe7d813f10d8f0f8473beac021676677a0c80" => :mavericks
    sha1 "40b646ef16c03659880d93ca80c3fa2a1589b156" => :mountain_lion
    sha1 "d5cd3ebb9df57a37855282bee6a198859253c50d" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make install"
  end
end
