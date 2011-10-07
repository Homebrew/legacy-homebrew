require 'formula'

class SdlSound < Formula
  url 'http://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz'
  homepage 'http://icculus.org/SDL_sound/'
  md5 'aa09cd52df85d29bee87a664424c94b5'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvorbis' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make install"
  end
end
