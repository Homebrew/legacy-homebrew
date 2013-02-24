require 'formula'

# must compile with gcc, so 'brew install --use-llvm nfft'
# this installs headers and shared+static libnfft3 libraries

class Nfft < Formula
  homepage 'http://www-user.tu-chemnitz.de/~potts/nfft'
  url 'http://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.2.2.tar.gz'
  sha1 '68c0ebc258254d823a41ff9d599dd9914eb6f6df'

  depends_on 'fftw'

  fails_with :clang do
    build 425
    cause "dot+=conj(x[k])*x[k] compound not yet supported by clang"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # compiles with gcc (the build can parallelize)
  end

end
