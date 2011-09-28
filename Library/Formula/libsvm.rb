require 'formula'

class Libsvm < Formula
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.11.tar.gz'
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  md5 '44d2a3a611280ecd0d66aafe0d52233e'

  def install
    system "make"
    bin.install ['svm-scale', 'svm-train', 'svm-predict']
  end
end
