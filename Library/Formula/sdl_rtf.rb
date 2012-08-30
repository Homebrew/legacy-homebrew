require 'formula'

class SdlRtf < Formula
  homepage 'http://www.libsdl.org/projects/SDL_rtf/'
  url 'http://www.libsdl.org/projects/SDL_rtf/release/SDL_rtf-0.1.0.tar.gz'
  md5 'fe36733167b5c89f128414f32612121a'

  head 'http://hg.libsdl.org/SDL_rtf', :using => :hg

  depends_on 'sdl'
  depends_on 'sdl_ttf'
  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
