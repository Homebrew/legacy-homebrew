require 'formula'

class Liblastfm < Formula
  homepage 'https://github.com/lastfm/liblastfm/'
  url 'https://github.com/lastfm/liblastfm/archive/1.0.8.tar.gz'
  sha1 '5ef084d0ba27c5e2bc1ec1754618ded0cd2b430e'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'fftw'
  depends_on 'libsamplerate'

  def install
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make', 'install'
    end
  end
end
