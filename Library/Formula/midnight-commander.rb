require 'formula'

class MidnightCommander < Formula
  url 'http://www.midnight-commander.org/downloads/mc-4.7.5.3.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  homepage 'http://www.midnight-commander.org/'
  sha256 '0875b4c745d771b65ab71d0a295f2e6e91297121411a82068e2879f39a7628b6'

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
