class Liblinear < Formula
  desc "Library for large linear classification"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/liblinear/"
  url "https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-2.1.tar.gz"
  version "2.10"
  sha256 "fa5c12dedc76ffca12f1681de7073b03af68163c4e4be65194217c99e55a7d68"

  head "https://github.com/cjlin1/liblinear.git"

  bottle do
    cellar :any
    sha256 "9666b2b726dfb6dc7b6f0533d6759ad48aa8739ceb6a5a015662b6ee75d201a8" => :el_capitan
    sha256 "598b49c62a755a47f64d3bf2f51f11863d3b3e10b2e237e3b567f89e0c22bd60" => :yosemite
    sha256 "978592ff57dedde12f550315ba3e01616faa27d88eae52c646e685568fc68f40" => :mavericks
  end

  # Fix sonames
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/941ec0ad/liblinear/patch-Makefile.diff"
    sha256 "ffb5206f0a6c15832574ec77863cda12eb2012e0f052bacebfe1ad722d31ea22"
  end

  def install
    system "make", "all"
    bin.install "predict", "train"
    lib.install "liblinear.dylib"
    lib.install_symlink "liblinear.dylib" => "liblinear.1.dylib"
    include.install "linear.h"
  end

  test do
    (testpath/"train_classification.txt").write <<-EOS.undent
    +1 201:1.2 3148:1.8 3983:1 4882:1
    -1 874:0.3 3652:1.1 3963:1 6179:1
    +1 1168:1.2 3318:1.2 3938:1.8 4481:1
    +1 350:1 3082:1.5 3965:1 6122:0.2
    -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    system "#{bin}/train", "train_classification.txt"
  end
end
