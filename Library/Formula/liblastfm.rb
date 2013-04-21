require 'formula'

class Liblastfm < Formula
  homepage 'https://github.com/mxcl/liblastfm/'
  url 'https://github.com/mxcl/liblastfm/archive/e380c7f03f4b2417db87372df733606f4a153c53.tar.gz'
  version '0.3.3.1'
  sha1 '68c0d23364afd7e6bb5dbd9b71419d808fe0d005'

  depends_on 'qt'
  depends_on 'fftw'
  depends_on 'libsamplerate'

  def install
    system "./configure", "--release", "--prefix", prefix
    system "make"
    system "make install"
  end
end
