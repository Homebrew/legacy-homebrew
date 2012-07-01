require 'formula'

class SdlImage < Formula
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.10.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_image'
  md5 '6c06584b31559e2b59f2b982d0d1f628'

  depends_on 'sdl'
  depends_on :x11 # for Freetype

  def options
    [['--universal', 'Build universal binaries.']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    inreplace 'SDL_image.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-freetype-exec-prefix=#{MacOS.x11_prefix}"
    system "make install"
  end
end
