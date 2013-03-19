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
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    if build.stable?
      inreplace %w[sdl.pc.in sdl-config.in], '@prefix@', HOMEBREW_PREFIX
    else
      inreplace %w[sdl2.pc.in sdl2-config.in], '@prefix@', HOMEBREW_PREFIX
    end
    
    ENV.universal_binary if build.universal?
      
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make install"
  end
end