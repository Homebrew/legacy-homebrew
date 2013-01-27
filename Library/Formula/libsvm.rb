require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/oldfiles/libsvm-3.16.tar.gz'
  sha1 '9274b96e4914bfbe0b3beae00e69f2293a3ca039'

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make lib"
    mv 'libsvm.so.2', 'libsvm.2.dylib'
    ln_s 'libsvm.2.dylib', 'libsvm.dylib'

    bin.install 'svm-scale', 'svm-train', 'svm-predict'
    lib.install 'libsvm.2.dylib', 'libsvm.dylib'
    include.install 'svm.h'
  end
end
