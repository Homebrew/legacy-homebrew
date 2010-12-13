require 'formula'

class Lame <Formula
  homepage 'http://lame.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/lame/lame-3.98.4.tar.gz'
  md5 '8e9866ad6b570c6c95c8cba48060473f'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--enable-nasm"
    system "make install"
  end
end