require 'formula'

class Lame < Formula
  homepage 'http://lame.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/lame/lame-3.99.1.tar.gz'
  md5 '2576a7368b5c90a87adc9de6b9f0628c'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--enable-nasm"
    system "make install"
  end
end
