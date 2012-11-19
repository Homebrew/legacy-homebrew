require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.14.tar.gz'
  sha1 'a069116cd38723203e16e85a2a2d1cf5d038a06a'

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
