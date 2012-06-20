require 'formula'

class Liblastfm < Formula
  homepage 'https://github.com/mxcl/liblastfm/'
  url 'https://github.com/mxcl/liblastfm/tarball/0.3.3'
  md5 'fe339bf46aefc515c251200d10262f79'

  depends_on 'qt'
  depends_on 'fftw'
  depends_on 'libsamplerate'

  # See issue #12886.  Reported in: https://github.com/mxcl/liblastfm/issues/14
  fails_with :clang do
    build 318
    cause 'error: reference to non-static member function must be called'
  end

  def install
    system "./configure", "--release", "--prefix", prefix
    system "make"
    system "make install"
  end
end
