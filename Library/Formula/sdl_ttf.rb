require 'formula'

class SdlTtf < Formula
  homepage 'http://www.libsdl.org/projects/SDL_ttf/'
  url 'http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz'
  sha1 '0ccf7c70e26b7801d83f4847766e09f09db15cc6'

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
