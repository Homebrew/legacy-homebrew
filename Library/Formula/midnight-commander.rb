require 'formula'

class MidnightCommander <Formula
  url 'http://www.midnight-commander.org/downloads/40'
  homepage 'http://www.midnight-commander.org/'
  sha256 '9f75d9f73ef3398d1ccea273997f37d0271fc171619a65b76c01fd0b30298d8a'
  version '4.7.0.4'

  depends_on 'glib'
  depends_on 'pkg-config'

  aka 'mc'

  def install
    system "./configure", "--prefix=#{prefix}","--without-x","--with-screen=ncurses", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
