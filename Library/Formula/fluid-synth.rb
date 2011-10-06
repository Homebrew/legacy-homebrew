require 'formula'

class FluidSynth < Formula
  url 'http://sourceforge.net/projects/fluidsynth/files/fluidsynth-1.1.5/fluidsynth-1.1.5.tar.gz'
  homepage 'http://www.fluidsynth.org/'
  sha1 '2f98696ca0a6757684f0a881bf92b3149536fdf2'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libsndfile' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "prefix=#{prefix}", "--enable-double"
    system "make install"
  end

  def test
    system "#{HOMEBREW_PREFIX}/bin/fluidsynth -V"
    oh1 "The test was successful"
  end
end
