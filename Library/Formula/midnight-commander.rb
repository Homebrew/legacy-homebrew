require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://www.midnight-commander.org/downloads/mc-4.8.8.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  mirror 'http://fossies.org/linux/misc/mc-4.8.8.tar.bz2'
  sha256 '7b5e6f90e6709d1c1bcb4a2bf6d2a62b9494adef3ff4325ffdb3551c29e42a1c'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 's-lang'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-screen=slang"
    system "make install"
  end
end
