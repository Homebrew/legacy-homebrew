require 'formula'

class Liblinear < Formula
  desc "Library for large linear classification"
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-1.96.tar.gz'
  sha1 '54de76b5e37cc3f200857e7a4cee0da21f0eefbc'

  bottle do
    cellar :any
    sha256 "72fe174f6e5cb9b3ace806b7e8670754c99a99845b77e3e66e3727722ecf1cb4" => :yosemite
    sha256 "3500b2793ba1dda65874a5b0ad904e54190dbb0a6606f52e0cc14bf5a685a484" => :mavericks
    sha256 "63386c19acd403e30bc34380c56299c823ceb5b22df620fdb57501f13e59728a" => :mountain_lion
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
