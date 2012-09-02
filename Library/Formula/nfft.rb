require 'formula'

# must compile with gcc, so 'brew install --use-llvm nfft'
# this installs headers and shared+static libnfft3 libs

class Nfft < Formula
  homepage 'http://www-user.tu-chemnitz.de/~potts/nfft'
  url 'http://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.2.0.tar.gz'
  sha1 '78d534e0de66f79c252e03d69d7a65f9ce766e6e'

  depends_on 'fftw'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # compiles with gcc (the build can parallelize)
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test nfft`.
    system "false"
  end
end
