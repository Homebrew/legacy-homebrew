require 'formula'

class SdlNet < Formula
  homepage 'http://www.libsdl.org/projects/SDL_net/'
  url 'http://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz'
  sha1 'fd393059fef8d9925dc20662baa3b25e02b8405d'

  head 'http://hg.libsdl.org/SDL_net', :using => :hg

  if build.head?
    depends_on :automake
    depends_on :libtool
  end
  
  depends_on 'pkg-config' => :build
  depends_on 'sdl'

  option :universal

  def install
    ENV.universal_binary if build.universal?
      
    system "./autogen.sh" if build.head?
    
    system "./configure"
    
    system "make install"
  end
end
