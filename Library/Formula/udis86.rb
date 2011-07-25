require 'formula'

class Udis86 < Formula
  url 'http://downloads.sourceforge.net/udis86/udis86-1.7.tar.gz'
  md5 'e279108e10f774e6c3af83caa18f5dc3'
  homepage 'http://udis86.sourceforge.net'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
