require 'formula'

class Clam < Formula
  homepage 'http://clam-project.org'
  url 'http://clam-project.org/download/src/CLAM-1.4.0.tar.gz'
  sha1 '32acbdc64e641b4a666e8e58e008430a6a906cd0'

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
