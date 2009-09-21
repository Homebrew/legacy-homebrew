require 'brewkit'

class Liblastfm <Formula
  @homepage='http://github.com/mxcl/liblastfm/'
  @url='http://static.last.fm/src/liblastfm-0.3.0.tar.bz2'
  @md5='3f73222ebc31635941832b01e7a494b6'

  depends_on 'qt'
  depends_on 'fftw'
  depends_on 'samplerate'

  def install
    system "./configure --release --prefix '#{prefix}'"
    system "make"
    system "make install"
  end
end