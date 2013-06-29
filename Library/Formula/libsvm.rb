require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/oldfiles/libsvm-3.17.tar.gz'
  sha1 'f6e5b238f89368f3e4c9ac65278ad8660d80c85c'

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
