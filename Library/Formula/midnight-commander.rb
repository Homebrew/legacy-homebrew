require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://www.midnight-commander.org/downloads/mc-4.8.9.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  mirror 'http://fossies.org/linux/misc/mc-4.8.9.tar.bz2'
  sha256 '7e184cf5ed3ff8b93fcbfff16608c1444920f523beda2fcc586878d619ea11da'

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
