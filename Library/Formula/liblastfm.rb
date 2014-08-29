require 'formula'

class Liblastfm < Formula
  homepage 'https://github.com/lastfm/liblastfm/'
  url 'https://github.com/lastfm/liblastfm/archive/1.0.8.tar.gz'
  sha1 '5ef084d0ba27c5e2bc1ec1754618ded0cd2b430e'

  bottle do
    sha1 "6e0c36f24cbfd9b6cc68b7146cdf46e1a8d79061" => :mavericks
    sha1 "a3c41ed49fa3533e6b88ca847b16a2914bcd5b99" => :mountain_lion
    sha1 "5e38d052f9a9d1a84c16675fa4daf98e72a87860" => :lion
  end

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
