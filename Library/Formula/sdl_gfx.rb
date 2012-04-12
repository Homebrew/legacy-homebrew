require 'formula'

class SdlGfx < Formula
  url 'http://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-2.0.20.tar.gz'
  homepage 'http://www.ferzkopp.net/joomla/content/view/19/14/'
  md5 '8a787e538a8e4d80d4927535be5af083'

  depends_on 'sdl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static=no",
                          "--enable-shared=yes",
                          "--disable-sdltest",
                          "--disable-mmx"
    system "make install"
  end
end
