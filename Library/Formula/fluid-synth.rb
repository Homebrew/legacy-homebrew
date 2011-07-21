require 'formula'

class FluidSynth < Formula
  url 'http://sourceforge.net/projects/fluidsynth/files/fluidsynth-1.1.3/fluidsynth-1.1.3.tar.gz'
  homepage 'http://www.fluidsynth.org/'
  md5 '0d3e3cc770b4da413010dfb7dfdce9c8'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libsndfile' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
