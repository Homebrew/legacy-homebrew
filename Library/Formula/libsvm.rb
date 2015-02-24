require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.20.tar.gz'
  sha1 '6902c22afadc70034c0d1c0e25455df10fb01eaf'

  bottle do
    cellar :any
    sha1 "9a87d885fd4d943448c9107fe572ed0b5687bf5b" => :yosemite
    sha1 "8fcd71c75841c4def48a4f57312ab5aae4ee628e" => :mavericks
    sha1 "90e7456fa54524a2a12f563ae3e9bcab57d6ade7" => :mountain_lion
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
