require 'formula'

class Lame < Formula
  homepage 'http://lame.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/lame/lame-3.99.5.tar.gz'
  md5 '84835b313d4a8b68f5349816d33e07ce'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--enable-nasm"
    system "make install"
  end
end
