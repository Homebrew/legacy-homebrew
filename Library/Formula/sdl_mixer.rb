require 'brewkit'

class SdlMixer <Formula
  url 'http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.8.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  md5 '0b5b91015d0f3bd9597e094ba67c4d65'

  depends_on 'sdl'

  def install
    # We use a private include folder, and then
    # symlink the header file ourselves.
    # See: http://github.com/mxcl/homebrew/issues#issue/62
    system "./configure", "--prefix=#{prefix}",
                          "--includedir=#{prefix}/priv_include",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make install"
    
    # Hack alert:
    # Since SDL is installed as a depency, we know it exists, so we
    # symlink our new header file into its brewed location.
    system "ln", "-s", "#{prefix}/priv_include/SDL/SDL_mixer.h", "#{HOMEBREW_PREFIX}/include/SDL"
  end
end
