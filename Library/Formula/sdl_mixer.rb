require 'formula'

class SdlMixer < Formula
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  url 'http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz'
  sha1 'a20fa96470ad9e1052f1957b77ffa68fb090b384'

  depends_on 'sdl'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  depends_on 'libvorbis' => :optional

  def install
    inreplace 'SDL_mixer.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
