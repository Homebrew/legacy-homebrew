require 'formula'

class Sdl2Net < Formula
  homepage 'http://www.libsdl.org/projects/SDL_net/'
  url 'http://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.0.tar.gz'
  sha1 'c7cf473b3adada23171df9f92b3117052eac69fa'

  depends_on 'sdl2'
  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace 'SDL2_net.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
