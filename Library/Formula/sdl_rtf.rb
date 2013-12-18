require 'formula'

class SdlRtf < Formula
  homepage 'http://www.libsdl.org/projects/SDL_rtf/'
  url 'http://www.libsdl.org/projects/SDL_rtf/release/SDL_rtf-0.1.0.tar.gz'
  sha1 'daf749fd87b1d76cd43880c9c5b61c9741847197'

  head 'http://hg.libsdl.org/SDL_rtf', :using => :hg

  depends_on 'sdl'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
