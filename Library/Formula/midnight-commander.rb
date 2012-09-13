require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'https://www.midnight-commander.org/downloads/mc-4.8.5.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  sha256 '92c58ad388360fe39f4affd66596a3f9c21dff19f001c5fb05f0349bb0049d4b'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 's-lang'

  def install
    # Fix encoding issues (double question marks instead of UTF-8 characters)
    # Confirmed to work on OSX 10.6 (with XCode 4.2 for Show Leopard) and OSX 10.7
    # 1. Remove references to external gettext
    ENV.remove "LDFLAGS", "-L/usr/local/opt/gettext/lib"
    ENV.remove "CPPFLAGS", "-I/usr/local/opt/gettext/include"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-included-gettext", # 2. Enable internal gettext
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--with-screen=slang"
    system "make install"
  end
end
