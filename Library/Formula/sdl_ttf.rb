require 'formula'

class SdlTtf <Formula
  url 'http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.9.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_ttf/'
  md5 '6dd5a85e4924689a35a5fb1cb3336156'

  depends_on 'sdl'

  def install
    ENV.x11 # For Freetype

    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{prefix}/priv_include",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-freetype-exec-prefix=/usr/X11"
    system "make install"

    # Hack alert:
    # Since SDL is installed as a dependency, we know it exists, so we
    # symlink our new header file into its brewed location.
    FileUtils.ln_s "#{prefix}/priv_include/SDL/SDL_ttf.h", "#{HOMEBREW_PREFIX}/include/SDL"
  end
end
