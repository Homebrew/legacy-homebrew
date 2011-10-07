require 'formula'

class SdlNet < Formula
  url 'http://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.7.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_net/'
  md5 '6bd4662d1423810f3140d4da21b6d912'

  depends_on 'sdl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make install"
  end
end
