require 'formula'

class SdlRtf < Formula
  homepage 'http://www.libsdl.org/projects/SDL_rtf/'
  url 'http://www.libsdl.org/projects/SDL_rtf/release/SDL_rtf-0.1.0.tar.gz'
  sha1 'daf749fd87b1d76cd43880c9c5b61c9741847197'

  head 'http://hg.libsdl.org/SDL_rtf', :using => :hg

  if build.head?
    depends_on :automake
    depends_on :libtool
  end
  
  depends_on 'sdl'

  option :universal

  def install
    ENV.universal_binary if build.universal?
      
    system "./autogen.sh" if build.head?
    
    system "./configure"
    
    system "make install"
  end
end
