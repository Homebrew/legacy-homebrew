require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/oldfiles/libsvm-3.19.tar.gz'
  sha1 '0130bdfc66bce43d105c069f6a4c0767efd95c9f'

  option "with-tools", "Add data-manipulation tools included in libsvm."
  depends_on "gnuplot" if build.with? "tools"

  bottle do
    cellar :any
    revision 1
    sha1 "90aa0337c4b35d26d3c51283dc69a3f6d3221824" => :yosemite
    sha1 "dd4e5a85187a0729083cdb1adfb69bd54d5c2cd9" => :mavericks
    sha1 "697539637c9cb4e007f1124822ef1c92bc5f90ed" => :mountain_lion
  end

  def install
    if build.with? "tools"
      inreplace "tools/easy.py", /"..\/(svm-.+)"/, "\"#{bin}/\\1\""
      inreplace "tools/grid.py", /'..\/svm-train'/, "'#{bin}/svm-train'"
      inreplace "tools/grid.py", /'\/usr\/bin\/gnuplot'/, "'#{HOMEBREW_PREFIX}/opt/gnuplot/bin/gnuplot'"
      bin.install "tools/checkdata.py" => "svm-checkdata"
      bin.install "tools/easy.py" => "svm-easy"
      bin.install "tools/grid.py" => "svm-grid"
      bin.install "tools/subset.py" => "svm-subset"
    end
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    lib.install "libsvm.so.2" => "libsvm.2.dylib"
    lib.install_symlink "libsvm.2.dylib" => "libsvm.dylib"
    system "install_name_tool", "-id", "#{lib}/libsvm.2.dylib", "#{lib}/libsvm.2.dylib"
    include.install "svm.h"
  end
end
