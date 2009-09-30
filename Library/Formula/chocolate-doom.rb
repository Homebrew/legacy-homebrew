require 'brewkit'

class ChocolateDoom <Formula
  url 'http://downloads.sourceforge.net/project/chocolate-doom/chocolate-doom/1.2.1/chocolate-doom-1.2.1.tar.gz'
  homepage 'http://www.chocolate-doom.org/'
  md5 'df04c380034eff789e6b9ee1c0164977'

  depends_on 'sdl'
  depends_on 'sdl_net'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    system "make install"
    
    # This project installs to 'games', but we want it in 'bin' so it symlinks in.
    # Can't find a ./configure switch, so just rename it.
    (prefix+"games").rename bin
  end
  
  def caveats
    "Note that this formula only installs a Doom game engine, and no\n"\
    "actual levels. The original Doom levels are still under copyright, \n"\
    "so you can copy them over and play them if you already own them.\n\n"\
    "Otherwise, there are tons of free levels available online.\n"\
    "Try starting here:\n\t#{homepage}"
  end
end
