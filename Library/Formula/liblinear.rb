require 'formula'

class Liblinear < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-1.94.tar.gz'
  sha1 '19678355e6c933b7ec133e07fef77796e50df0d5'

  bottle do
    cellar :any
    revision 1
    sha1 "b1b7231ae951b2fecfbe07bda0464631a6154262" => :yosemite
    sha1 "49be96f0e6bbd433345571ad6518c76ebacf6ce4" => :mavericks
    sha1 "1e10cbc1730d6237edb6b71fb8792a47c83c1d49" => :mountain_lion
  end

  # Fix sonames
  patch :p0 do
    url "https://trac.macports.org/export/94156/trunk/dports/math/liblinear/files/patch-Makefile.diff"
    sha1 "3eab2f28bd9964bacb515ecc1ce9bea35ad29298"
  end

  def install
    system "make", "all"
    bin.install "predict", "train"
    lib.install "liblinear.dylib"
    lib.install_symlink "liblinear.dylib" => "liblinear.1.dylib"
    include.install "linear.h"
  end
end
