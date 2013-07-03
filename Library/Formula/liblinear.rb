require 'formula'

class Liblinear < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-1.93.tar.gz'
  sha1 '88aac78a7ba163a3cd528e934219a56c0e1e2d86'

  # Fix sonames
  def patches
    { :p0 => [
      "https://trac.macports.org/export/94156/trunk/dports/math/liblinear/files/patch-Makefile.diff"
    ]}
  end

  def install
    system "make all"
    ln_s 'liblinear.dylib', 'liblinear.1.dylib'

    bin.install 'predict', 'train'
    lib.install 'liblinear.1.dylib', 'liblinear.dylib'
    include.install 'linear.h'
  end
end
