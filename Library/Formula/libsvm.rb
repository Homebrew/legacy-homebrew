require 'formula'

class Libsvm < Formula
  url 'http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/libsvm.cgi?+http://www.csie.ntu.edu.tw/~cjlin/libsvm+tar.gz'
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  md5 'a157c1edfdb290fe8081d6a011022055'
  version '3.1'

  def install
    system "make"
    bin.install('svm-scale')
    bin.install('svm-train')
    bin.install('svm-predict')
  end
end
