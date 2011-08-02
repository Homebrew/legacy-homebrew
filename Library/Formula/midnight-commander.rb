require 'formula'

class MidnightCommander < Formula
  url 'http://www.midnight-commander.org/downloads/mc-4.7.5.1.tar.bz2'
  homepage 'http://www.midnight-commander.org/'
  sha256 '4d60a9fcd186b70f52d4e730ae3d43408a73e3f0647968e9f4af8005f13369e9'

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
