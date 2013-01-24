require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://www.midnight-commander.org/downloads/mc-4.8.7.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  sha256 '4e9c45925b47650dac58d7556a89c3e9b4275e48976b6c13b63c2f8eed3a383b'

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
