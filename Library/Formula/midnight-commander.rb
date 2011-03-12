require 'formula'

class MidnightCommander <Formula
  url 'http://www.midnight-commander.org/downloads/mc-4.7.5.tar.bz2'
  homepage 'http://www.midnight-commander.org/'
  sha256 '0d2b4e87b8a4158edf54380df9402b4a1a19f7494ef06dd0a0a3e3ff6a2b50f1'

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
