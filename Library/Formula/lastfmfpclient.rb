require 'formula'

class Lastfmfpclient < Formula
  url 'https://github.com/lastfm/Fingerprinter/tarball/9ee83a51ac9058ff53c9'
  version '1.6'
  homepage 'https://github.com/lastfm/Fingerprinter'
  md5 'ab909b4d6dcc6182afae616749ce0fdc'

  depends_on 'cmake' => :build
  depends_on 'taglib'
  depends_on 'fftw'
  depends_on 'mad'
  depends_on 'libsamplerate'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
