require 'formula'

class Mednafen <Formula
  homepage 'http://mednafen.sourceforge.net/'
  url 'https://sourceforge.net/projects/mednafen/files/Mednafen/0.8.D.3/mednafen-0.8.D.3.tar.bz2/download'
  md5 '57d22805071becd81858b0c088a275e5'
  version '0.8.D.3'

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
