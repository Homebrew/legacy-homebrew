require 'brewkit'

class SdlImage <Formula
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.7.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_image'
  md5 'a729ff61f74f0a45ec7fe36354cf938e'

  depends_on 'libpng'
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
    FileUtils.ln_s "#{prefix}/priv_include/SDL/SDL_image.h", "#{HOMEBREW_PREFIX}/include/SDL"
  end
end
