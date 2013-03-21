require 'formula'

class SdlMixer < Formula
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  url 'http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz'
  sha1 'a20fa96470ad9e1052f1957b77ffa68fb090b384'

  head 'http://hg.libsdl.org/SDL_mixer', :using => :hg

  if build.head?
    depends_on :automake
    depends_on :libtool
  end
  
  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  depends_on 'libvorbis' => :optional

  option :universal

  def install
    ENV.universal_binary if build.universal?

    inreplace 'SDL_mixer.pc.in', '@prefix@', HOMEBREW_PREFIX if build.stable?

    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
