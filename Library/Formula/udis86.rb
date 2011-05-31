require 'formula'

class Udis86 < Formula
  url 'http://downloads.sourceforge.net/project/udis86/udis86/1.7/udis86-1.7.tar.gz'
  homepage 'http://udis86.sourceforge.net'
  md5 'e279108e10f774e6c3af83caa18f5dc3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-shared"
    system "make install"
  end
end
