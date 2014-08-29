require 'formula'

class Sdl2Mixer < Formula
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  url 'http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz'
  sha1 '9ed975587f09a1776ba9776dcc74a58e695aba6e'

  head 'http://hg.libsdl.org/SDL_mixer', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'sdl2'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  depends_on 'libvorbis' => :optional

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace 'SDL2_mixer.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
