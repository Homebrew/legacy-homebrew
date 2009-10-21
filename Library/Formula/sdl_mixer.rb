require 'formula'

class SdlMixer <Formula
  url 'http://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.9.tar.gz'
  homepage 'http://www.libsdl.org/projects/SDL_mixer/'
  md5 'a9eb8750e920829ff41dbe7555850156'

  depends_on 'sdl'
  depends_on 'flac' => :optional
  depends_on 'libmikmod' => :optional
  #depends_on 'smpeg' => :optional  # http://icculus.org/smpeg/
  
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
    # Since SDL is installed as a dependency, we know it exists, so we
    # symlink our new header file into its brewed location.
    FileUtils.ln_s "#{prefix}/priv_include/SDL/SDL_mixer.h", "#{HOMEBREW_PREFIX}/include/SDL"
  end
end
