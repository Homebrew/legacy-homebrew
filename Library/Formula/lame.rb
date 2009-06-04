require 'brewkit'

class Lame <Formula
  @homepage='http://lame.sourceforge.net/'
  @url='http://kent.dl.sourceforge.net/sourceforge/lame/lame-398-2.tar.gz'
  @md5='719dae0ee675d0c16e0e89952930ed35'

  def install
    system "./configure --disable-debug --prefix='#{prefix}' --enable-nasm"
    system "make install"
  end
end