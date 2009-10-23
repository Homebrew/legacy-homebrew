require 'formula'

class SdlImage <Formula
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.8.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_image'
  md5 '2e7c3efa0ec2acc039c46960e27c0792'

  depends_on 'libpng'
  depends_on 'sdl'

  def install
    ENV.x11 # For Freetype

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-freetype-exec-prefix=/usr/X11"
    system "make install"
  end
end
