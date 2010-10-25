require 'formula'

class MidnightCommander <Formula
  url 'http://www.midnight-commander.org/downloads/mc-4.7.4.tar.bz2'
  homepage 'http://www.midnight-commander.org/'
  sha256 '3c8fb2cf3361958552b7397e7aa9400f8b35338da2668b4ed7b4f0e4c5377e9a'
  version '4.7.4'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-samba",
                          "--with-screen=ncurses"
    system "make install"
  end
end
