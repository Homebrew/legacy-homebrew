require 'formula'

class Mednafen <Formula
  homepage 'http://mednafen.sourceforge.net/'
#  url 'http://mednafen.sourceforge.net/releases/mednafen-0.8.C.tar.bz2'
#  md5 'e8f4b6ba7ed2eca399b02578e1803831'
#  version '0.8.C'
  url 'http://forum.fobby.net/index.php?t=getfile&id=192'
  md5 'f50882095931a44df828e1254ed1a461'
  version '0.8.D'  # actually 0.8.Drc1

  depends_on 'pkg-config'
  depends_on 'sdl'
  depends_on 'sdl_net'
  depends_on 'libcdio'
  depends_on 'libsndfile'

  def install
    # someone with more C++ juice than me can undertake to patch the 
    # crasher in Blip_Synth<8, 1>::offset_resampled that happens with
    # even minimal optimizations turned on (in LLVM or GCC 4.2)
    ENV.no_optimization
    
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
