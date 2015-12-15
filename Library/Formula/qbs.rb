class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "https://download.qt.io/official_releases/qbs/1.4.4/qbs-src-1.4.4.tar.gz"
  sha256 "23fb37bfbe775907a2593f716b17151f25995ec37cd5bedabaf266781078b404"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "5d94dc85f7d7f3215d9930cbabcf9a2ceb7ab3899468f78bbd628fe60f3216ff" => :el_capitan
    sha256 "f2179c4003a7d2fff052844872218b4c94a8548ce3c6aa29359eba66c1ef3b0f" => :yosemite
    sha256 "4cfecaa5d4dd45d6be7aa6a2ab6b3192f24dbed3b3839699cec3896dc86030a2" => :mavericks
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
