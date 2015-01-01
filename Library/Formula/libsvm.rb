require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.20.tar.gz'
  sha1 '6902c22afadc70034c0d1c0e25455df10fb01eaf'

  bottle do
    cellar :any
    revision 1
    sha1 "90aa0337c4b35d26d3c51283dc69a3f6d3221824" => :yosemite
    sha1 "dd4e5a85187a0729083cdb1adfb69bd54d5c2cd9" => :mavericks
    sha1 "697539637c9cb4e007f1124822ef1c92bc5f90ed" => :mountain_lion
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
