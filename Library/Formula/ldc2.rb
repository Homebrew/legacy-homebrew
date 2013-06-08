require 'formula'

class Ldc2 < Formula
  version '20130608'
  url 'https://bitbucket.org/clems71/homebrew-ldc2/downloads/ldc2-2013-06-08.zip'
  homepage 'https://github.com/ldc-developers/ldc'
  sha1 '4352ee0256f3be9926d8d0497344b768f51ce22a'

  depends_on 'cmake' => :build
  depends_on 'llvm'
  depends_on 'libconfig'

  def install
    system "cmake", ".", *std_cmake_args
    system "make -j4 install"
  end
end
