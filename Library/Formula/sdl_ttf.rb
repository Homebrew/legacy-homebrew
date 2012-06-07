require 'formula'

class SdlTtf < Formula
  url 'http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.9.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_ttf/'
  md5 '6dd5a85e4924689a35a5fb1cb3336156'

  depends_on 'sdl'
  depends_on :x11 # for Freetype

  def options
    [['--universal', 'Build universal binaries.']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--with-freetype-exec-prefix=#{MacOS.x11_prefix}"
    system "make install"
  end
end
