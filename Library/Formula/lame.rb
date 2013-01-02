require 'formula'

class Lame < Formula
  homepage 'http://lame.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/lame/lame-3.99.5.tar.gz'
  sha1 '03a0bfa85713adcc6b3383c12e2cc68a9cfbf4c4'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-nasm"
    system "make install"
  end
end
