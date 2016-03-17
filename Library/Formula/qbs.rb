class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "https://download.qt.io/official_releases/qbs/1.4.5/qbs-src-1.4.5.tar.gz"
  sha256 "f0089b422610cd57d517b146447cd4b45c9f4c4e72797116e3d27472a9cf0d19"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "05a7f29c42f055d6a679926071dd3b630de2a292c8c3cc52464710c7b3b8db34" => :el_capitan
    sha256 "26a6312cb1d399f7d3e0cac86ee697e8452959b9cdd90bde5b47a50585288f48" => :yosemite
    sha256 "d850b60a497e36c0aec5661112564a963cc6cda3dcbecd45eecd71bd10a94ac8" => :mavericks
  end

  depends_on "qt5"

  def install
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/"
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
