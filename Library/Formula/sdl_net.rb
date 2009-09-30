require 'brewkit'

class SdlNet <Formula
  url 'http://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.7.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_net/'
  md5 '6bd4662d1423810f3140d4da21b6d912'

  depends_on 'sdl'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{prefix}/priv_include",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    system "make install"

    # Hack alert:
    # Since SDL is installed as a depency, we know it exists, so we
    # symlink our new header file into its brewed location.
    FileUtils.ln_s "#{prefix}/priv_include/SDL/SDL_net.h", "#{HOMEBREW_PREFIX}/include/SDL"
  end
end
