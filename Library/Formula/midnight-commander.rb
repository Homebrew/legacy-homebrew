require 'formula'

class MidnightCommander < Formula
  url 'http://www.midnight-commander.org/downloads/mc-4.8.0.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  homepage 'http://www.midnight-commander.org/'
  sha256 'dbf077b318c13fc6d465dc67bd43958f067b9ff7e21041975bd14927dfa31b52'

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
