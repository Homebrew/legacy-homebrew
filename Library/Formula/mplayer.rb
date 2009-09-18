require 'brewkit'

class Mplayer <Formula
  @homepage='http://www.mplayerhq.hu/'
  @head='svn://svn.mplayerhq.hu/mplayer/trunk'

  def install
    # Information from http://blog.bloople.net/read/mplayer-on-snow-leopard
    # seems to claim that we have to build against an x86_64 target even if on
    # i386 /-:
    system "./configure --prefix='#{prefix}' --target=x86_64-Darwin"
    system "make"
    system "make install"
  end
end