require 'formula'

class MidnightCommander <Formula
  url 'http://mirror.anl.gov/pub/gnu/mc/mc-4.6.1.tar.gz'
  homepage 'http://www.midnight-commander.org/'
  md5 '18b20db6e40480a53bac2870c56fc3c4'

  depends_on 'glib'
  depends_on 'pkg-config'

  aka 'mc'

  def install
    system "./configure", "--prefix=#{prefix}","--without-x","--with-screen=ncurses", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
