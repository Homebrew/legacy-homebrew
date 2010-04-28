require 'formula'

class Mednafen <Formula
  homepage 'http://mednafen.sourceforge.net/'
  url 'http://forum.fobby.net/index.php?t=getfile&id=192'
  md5 'f50882095931a44df828e1254ed1a461'
  version '0.8.D-rc1'

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

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
