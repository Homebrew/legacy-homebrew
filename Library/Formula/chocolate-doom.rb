require 'formula'

class ChocolateDoom <Formula
  url 'http://downloads.sourceforge.net/project/chocolate-doom/chocolate-doom/1.3.0/chocolate-doom-1.3.0.tar.gz'
  homepage 'http://www.chocolate-doom.org/'
  md5 'c1b680b88e524b861d4e3fbc769c2e10'

  depends_on 'sdl'
  depends_on 'sdl_net'
  depends_on 'sdl_mixer'

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

  def caveats; <<-EOS.undent
    Note that this formula only installs a Doom game engine, and no
    actual levels. The original Doom levels are still under copyright,
    so you can copy them over and play them if you already own them.
    Otherwise, there are tons of free levels available online.
    Try starting here:
      #{homepage}
    EOS
  end
end
