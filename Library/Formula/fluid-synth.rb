require 'formula'

class FluidSynth <Formula
  url 'http://mirrors.zerg.biz/nongnu/fluid/fluidsynth-1.1.1.tar.gz'
  homepage 'http://fluidsynth.resonance.org/trac'
  md5 '0db3da78028d255026230809c6e21b44'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libsndfile' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
