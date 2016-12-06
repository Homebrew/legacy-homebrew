require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.3.2.tar.gz'
  sha1 '8ef7ccbf18a4fa6db712a9192acafc9c8d080978'

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile'
  depends_on 'libsamplerate'
  depends_on 'fftw'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
