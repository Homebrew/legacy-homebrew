require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://www.midnight-commander.org/downloads/mc-4.8.6.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  sha256 '17034d16cf5e86ed15e0f5de95238afb0a8c6069b1f0a29397042451c1b75877'

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
