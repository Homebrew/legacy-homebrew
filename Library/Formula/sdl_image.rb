require 'formula'

class SdlImage < Formula
  homepage 'http://www.libsdl.org/projects/SDL_image'
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz'
  sha1 '5e3e393d4e366638048bbb10d6a269ea3f4e4cf2'

  head 'http://hg.libsdl.org/SDL_image', :using => :hg

  if build.head?
    depends_on :automake
    depends_on :libtool
  end
  
  depends_on 'sdl'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace 'SDL_image.pc.in', '@prefix@', HOMEBREW_PREFIX if build.stable?
    
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    
    system "make install"
  end
end