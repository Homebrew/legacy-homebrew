require 'formula'

class Libsvm < Formula
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.11.tar.gz'
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  md5 '44d2a3a611280ecd0d66aafe0d52233e'

  def install
    inreplace 'Makefile', '-soname', '-install_name'
    inreplace 'Makefile', 'libsvm.so.$(SHVER)', 'libsvm.$(SHVER).dylib'

    system "make"
    system "make lib"
    ln_s 'libsvm.2.dylib', 'libsvm.dylib'

    bin.install ['svm-scale', 'svm-train', 'svm-predict']
    lib.install ['libsvm.2.dylib', 'libsvm.dylib']
    include.install ['svm.h']
  end
end
