class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  head "https://code.qt.io/qt-labs/qbs.git"
  url "https://download.qt.io/official_releases/qbs/1.4.3/qbs-src-1.4.3.tar.gz"
  sha256 "0c47291ac578c1fc8f2bd6ab20fbeeb58630c4c6ddc085f6081ae570f825f787"

  bottle do
    cellar :any
    sha256 "711702ab21e1d79ec8af07f79b7df5ca1f248bbc7a33bca5956d1d8d8f63d66b" => :yosemite
    sha256 "66104f7ef11819ab5ed04ae4389824e4e015b91e85cd21215b5a85d2e3c822b2" => :mavericks
    sha256 "fa16108941859b3b8ddfbc44d086e4401efb1583cf52e6f391b0710fb0e80b05" => :mountain_lion
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
