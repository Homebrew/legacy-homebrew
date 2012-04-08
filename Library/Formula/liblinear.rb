require 'formula'

class Liblinear < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/liblinear/liblinear-1.8.tar.gz'
  md5 'a2e642bbff3dc1f294c977c87f944f88'

  def install
    inreplace 'Makefile', 'liblinear.so.$(SHVER)', 'liblinear.$(SHVER).dylib'

    system "make"
    system "make lib"
    ln_s 'liblinear.1.dylib', 'liblinear.dylib'

    bin.install 'predict', 'train'
    lib.install 'liblinear.1.dylib', 'liblinear.dylib'
    include.install 'linear.h'
  end
end
