require 'formula'

class Udis86 < Formula
  homepage 'http://udis86.sourceforge.net'
  url 'http://downloads.sourceforge.net/udis86/udis86-1.7.tar.gz'
  sha1 '1a9949e33024542a24a948af5d9cbee34ff64695'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make install"
  end
end
