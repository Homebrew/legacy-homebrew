require 'formula'

class SdlTtf < Formula
  url 'http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.9.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_ttf/'
  md5 '6dd5a85e4924689a35a5fb1cb3336156'

  depends_on 'sdl'

  def install
    ENV.x11 # For Freetype

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--with-freetype-exec-prefix=/usr/X11"
    system "make install"
  end
end
