require 'formula'

class Openblas < Formula
  homepage 'http://xianyi.github.com/OpenBLAS/'
  url 'http://github.com/xianyi/OpenBLAS/zipball/v0.1.0'
  md5 '4a33238f68b84bd628701556f12131e0'

  def install
    ENV.fortran
    system "make", "NO_LAPACK=1"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
