class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.20.tar.gz"
  sha256 "0f122480bef44dec4df6dae056f468c208e4e08c00771ec1b6dae2707fd945be"

  bottle do
    cellar :any
    sha256 "2e5b46978c3d94b6c75fc07648c7c9a45735a304889a490908259c73c93b873b" => :el_capitan
    sha256 "2776a3869436f10a28f9b265283374900dce0e99c797c82f03fb4f23fd98278d" => :yosemite
    sha256 "860f812a691faa615a02ddf161cdc4cf90b50730aced1242208ec2f62c6ff40b" => :mavericks
    sha256 "0a1ae9e8f2a7788001a7628cbb50ee356ff7613e4c9661283d9eb82e55625156" => :mountain_lion
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
