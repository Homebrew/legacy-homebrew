require 'brewkit'

class Rogue <Formula
  url 'http://rogue.rogueforge.net/files/rogue5.4/rogue5.4.4-src.tar.gz'
  homepage 'http://rogue.rogueforge.net/'
  version '5.4.4'
  sha1 'aef9e589c4f31eb6d3eeb9d543ab8787b00fb022'

  def skip_clean? path
    path == libexec
  end
  
  def install
    if MACOS_VERSION == 10.6
      ENV.ncurses_define
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"

    inreplace "config.h", "rogue.scr", "#{libexec}/rogue.scr"
    
    system "make install"
    libexec.mkdir
  end
end
