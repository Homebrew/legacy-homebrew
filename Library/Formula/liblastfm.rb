require 'brewkit'

class Liblastfm <Formula
  @homepage='http://github.com/mxcl/liblastfm/'
  @url='http://static.last.fm/src/liblastfm-0.3.0.tar.bz2'
  @md5='3f73222ebc31635941832b01e7a494b6'

  def deps
    dep_test_bin 'qmake' or 'qt'
    dep_test_lib 'fftw3f' or 'fftw'
    dep_test_lib 'samplerate' or 'libsamplerate'
  end

  def install
    system "./configure --release --prefix '#{prefix}'"
    system "make"
    system "make install"
  end
end