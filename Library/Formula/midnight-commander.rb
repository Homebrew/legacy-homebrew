require 'formula'

class MidnightCommander <Formula
  url 'http://www.midnight-commander.org/downloads/31'
  homepage 'http://www.midnight-commander.org/'
  sha256 '71caeaf00606c45228362fb6a4d2f1b6d47b6c1056db46b975255aac5af45ef7'
  version '4.7.0.3'

  depends_on 'glib'
  depends_on 'pkg-config'

  aka 'mc'

  def install
    system "./configure", "--prefix=#{prefix}","--without-x","--with-screen=ncurses", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
