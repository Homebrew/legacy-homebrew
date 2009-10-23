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
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
