require 'brewkit'

class Liblastfm <Formula
  @homepage='http://github.com/mxcl/liblastfm/'
  @url='http://github.com/mxcl/liblastfm/tarball/0.3.0'
  @md5='08e90275ccd06476426a5002d1dad762'

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