require 'formula'

class SdlImage < Formula
  homepage 'http://www.libsdl.org/projects/SDL_image'
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz'
  sha1 '5e3e393d4e366638048bbb10d6a269ea3f4e4cf2'

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
