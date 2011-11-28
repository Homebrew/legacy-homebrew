require 'formula'

class Lame < Formula
  homepage 'http://lame.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/lame/lame-3.99.3.tar.gz'
  md5 '5ad31e33e70455eb3a7b79a5dd934fce'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--enable-nasm"
    system "make install"
  end
end
