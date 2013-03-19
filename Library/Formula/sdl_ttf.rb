require 'formula'

class SdlTtf < Formula
  homepage 'http://www.libsdl.org/projects/SDL_ttf/'
  url 'http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz'
  sha1 '0ccf7c70e26b7801d83f4847766e09f09db15cc6'
  
  head 'http://hg.libsdl.org/SDL_ttf', :using => :hg

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'sdl'  
  depends_on :freetype

  option :universal

  def install    
    ENV.universal_binary if build.universal?
      
    system "./autogen.sh" if build.head?
    
    system "./configure"
    
    system "make install"
  end
end