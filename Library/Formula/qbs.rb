require "formula"

class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "https://download.qt.io/official_releases/qbs/1.4.0/qbs-1.4.0.src.tar.gz"
  sha1 "4c70247155281b9536a6fab6672cd5f53610cfa1"

  bottle do
    sha256 "fa881458fc8700b9160bde642842e0baf75a4e221909a890c7ed6c1f191c4e32" => :yosemite
    sha256 "e211c32a20804c5d8386d825bb3846a6bb2b5bc360f2abdab577d5dc7288402f" => :mavericks
    sha256 "fbf2045061fdb7c148ec4c32843e29078810282ae28eb13c1289904953a3209d" => :mountain_lion
  end

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r"
    system "make", "install", "INSTALL_ROOT=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbp").write <<-EOS.undent
      import qbs

      CppApplication {
        name: "test"
        files: "test.c"
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "setup-toolchains", "--detect", "--settings-dir", testpath
    system "#{bin}/qbs", "run", "--settings-dir", testpath, "-f", "test.qbp", "profile:clang"
  end
end
