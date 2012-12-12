require 'formula'

class Liblastfm < Formula
  homepage 'https://github.com/mxcl/liblastfm/'
  url 'https://github.com/mxcl/liblastfm/tarball/e380c7f03f4b2417db87372df733606f4a153c53'
  version '0.3.3.1'
  sha1 'c68691b63a383f2a53a5894b99f165ffed4ea0db'

  depends_on 'qt'
  depends_on 'fftw'
  depends_on 'libsamplerate'

  def install
    system "./configure", "--release", "--prefix", prefix
    system "make"
    system "make install"
  end
end
