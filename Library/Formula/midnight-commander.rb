require 'formula'

class MidnightCommander < Formula
  homepage 'http://www.midnight-commander.org/'
  url 'http://www.midnight-commander.org/downloads/mc-4.8.4.tar.bz2',
      :using => CurlUnsafeDownloadStrategy
  sha256 '917f32a6ce0b8e3ec893bb18af73e64c246d79066322041608352623a579234b'

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
