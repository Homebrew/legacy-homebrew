require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/oldfiles/libsvm-3.18.tar.gz'
  sha1 '20bd3e2d21d79c3714007043475b92dfeed29135'

  bottle do
    cellar :any
    sha1 "91a43c30f20ec4ab045b4d021e379310c529b2d5" => :mavericks
    sha1 "c7d23b9a0704339446c298a9e2f1014942de54f3" => :mountain_lion
    sha1 "a0d618da51645b2c0fd63f1b25a95ef8bb39c63a" => :lion
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    lib.install "libsvm.so.2" => "libsvm.2.dylib"
    lib.install_symlink "libsvm.2.dylib" => "libsvm.dylib"
    system "install_name_tool", "-id", "#{lib}/libsvm.2.dylib", "#{lib}/libsvm.2.dylib"
    include.install "svm.h"
  end
end
