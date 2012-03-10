require 'formula'

class SdlSound < Formula
  url 'http://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz'
  homepage 'http://icculus.org/SDL_sound/'
  md5 'aa09cd52df85d29bee87a664424c94b5'
  head 'http://hg.icculus.org/icculus/SDL_sound', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'speex' => :optional
  depends_on 'physfs' => :optional

  def install
    system "./bootstrap" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    system "make"
    system "make check"
    system "make install"
  end
end
