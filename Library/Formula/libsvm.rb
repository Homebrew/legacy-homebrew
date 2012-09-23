require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.12.tar.gz'
  sha1 '6ee77eb3d89af07fe48058dba0dcc24c85020b85'

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
