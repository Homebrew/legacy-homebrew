require 'formula'

class Clam < Formula
  url 'http://clam-project.org/download/src/CLAM-1.4.0.tar.gz'
  homepage 'http://clam-project.org'
  md5 '614bb957a7aeecc667e144a46a1b87d2'

  depends_on 'scons' => :build
  depends_on 'xerces-c'
  depends_on 'fftw'
  depends_on 'libsndfile'
  depends_on 'libvorbis'
  depends_on 'mad'
  depends_on 'jack'
  depends_on 'portaudio'
  depends_on 'id3lib'

  def install
    system "scons", "configure", "prefix=#{prefix}", "with_ladspa=no", "xmlbackend=none"
    system "scons"
    system "scons install"
  end
end
