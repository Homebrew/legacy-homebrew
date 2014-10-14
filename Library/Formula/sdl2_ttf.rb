require 'formula'

class Sdl2Ttf < Formula
  homepage 'http://www.libsdl.org/projects/SDL_ttf/'
  url 'http://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz'
  sha1 '542865c604fe92d2f26000428ef733381caa0e8e'

  depends_on 'pkg-config' => :build
  depends_on 'sdl2'
  depends_on 'freetype'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace 'SDL2_ttf.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
