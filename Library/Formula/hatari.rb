require 'formula'

class Hatari < Formula
  homepage 'http://hatari.tuxfamily.org'
  url 'http://download.tuxfamily.org/hatari/1.6.2/hatari-1.6.2.tar.bz2'
  sha1 'fce28eb59d7b1574537bfdba757fddc31534bb17'

  depends_on 'cmake' => :build
  depends_on 'sdl'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-osx-bundle"
    system "make install"
  end
end
