require 'formula'

class MidnightCommander <Formula
  url 'http://www.midnight-commander.org/downloads/59'
  homepage 'http://www.midnight-commander.org/'
  sha256 '1b8e9650f092d4554eb08f137142bd203b5cef74b5000f3e228f0261fd92a039'
  version '4.7.0.8'

  depends_on 'pkg-config'
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-screen=ncurses"
    system "make install"
  end
end
