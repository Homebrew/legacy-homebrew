require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://www.midnight-commander.org/downloads/mc-4.8.10.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  mirror 'http://fossies.org/linux/misc/mc-4.8.10.tar.bz2'
  sha256 '5f4166fe78fbf4b42f51ed526ca7f79fea8c77d04355c2b97d4df2a6bd2a1b1a'

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
