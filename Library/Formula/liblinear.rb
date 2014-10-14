require 'formula'

class Liblinear < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-1.94.tar.gz'
  sha1 '19678355e6c933b7ec133e07fef77796e50df0d5'

  bottle do
    cellar :any
    sha1 "2abdfc1ed089473fdcb303179bcd1462c0a472aa" => :mavericks
    sha1 "536cd0730f75face8cfa791de405e9b3d092e6d4" => :mountain_lion
    sha1 "38dd7df4c233bb0ecf07c887be563e00de7004ca" => :lion
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
