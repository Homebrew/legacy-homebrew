require 'brewkit'

class Mplayer <Formula
  @homepage='http://www.mplayerhq.hu/'
  @url='http://www.mplayerhq.hu/MPlayer/releases/mplayer-checkout-snapshot.tar.bz2'
  @md5=''
  @verison='snapshot'

  def install
    system "./configure --disable-debug --prefix='#{prefix}'"
    system "make install"
  end
end