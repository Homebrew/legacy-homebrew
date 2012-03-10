require 'formula'
require Formula.path('sdl')

class SdlImage < Formula
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.10.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_image'
  md5 '6c06584b31559e2b59f2b982d0d1f628'

  depends_on 'sdl'

  def install
    ENV.x11 # For Freetype
    Sdl.use_homebrew_prefix 'SDL_image.pc.in'

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-freetype-exec-prefix=/usr/X11"
    system "make install"
  end
end
