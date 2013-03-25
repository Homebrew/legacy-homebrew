require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'ftp://ftp.gmplib.org/pub/gmp-5.1.1/gmp-5.1.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.1.1.tar.bz2'
  sha1 '21d037f7fb32ae305a2e4157cff0c8caab06fe84'

  bottle do
    cellar :any
    sha1 '6205bbef609caa99f3c52504139124dff58e3ada' => :mountain_lion
    sha1 '1e149d107deaa26b701abd191a409df06c8fbea0' => :lion
    sha1 '9eeb70ae6cb596ceb649d5ad313e35b1efdde3fd' => :snow_leopard
  end

  option '32-bit'

  def install
    if build.build_32_bit?
      ENV.m32
      ENV.append 'ABI', '32'
    end

    system "./configure", "--prefix=#{prefix}", "--enable-cxx"
    system "make"
    system "make check"
    ENV.deparallelize
    system "make install"
  end
end
