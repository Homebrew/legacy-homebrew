require 'formula'

class Libsamplerate < Formula
  homepage 'http://www.mega-nerd.com/SRC'
  url 'http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz'
  md5 '1c7fb25191b4e6e3628d198a66a84f47'

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile' => :optional
  depends_on 'fftw' => :optional

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
