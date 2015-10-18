class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.20.tar.gz"
  sha256 "0f122480bef44dec4df6dae056f468c208e4e08c00771ec1b6dae2707fd945be"

  bottle do
    cellar :any
    sha256 "2e5b46978c3d94b6c75fc07648c7c9a45735a304889a490908259c73c93b873b" => :el_capitan
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

  test do
    (testpath/"train_classification.txt").write <<-EOS.undent
    +1 201:1.2 3148:1.8 3983:1 4882:1
    -1 874:0.3 3652:1.1 3963:1 6179:1
    +1 1168:1.2 3318:1.2 3938:1.8 4481:1
    +1 350:1 3082:1.5 3965:1 6122:0.2
    -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath/"train_regression.txt").write <<-EOS.undent
    0.23 201:1.2 3148:1.8 3983:1 4882:1
    0.33 874:0.3 3652:1.1 3963:1 6179:1
    -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system "#{bin}/svm-train", "-s", "0", "train_classification.txt"
    system "#{bin}/svm-train", "-s", "3", "train_regression.txt"
  end
end
