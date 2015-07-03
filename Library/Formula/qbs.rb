require "formula"

class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "https://download.qt.io/official_releases/qbs/1.4.1/qbs-src-1.4.1.tar.gz"
  sha1 "05aac5341859159556bc0f3f1ba96c46179d12d3"

  bottle do
    sha256 "1a97288225e37a20e8686e5fa2cbbfed4f812becd03f1eb39e5ca9e9364273a3" => :yosemite
    sha256 "d1af3eccc7ed1ad98dee8eeb54739334648b68138784f7f672214037be9b9cea" => :mavericks
    sha256 "d05570afa0827c1adbf3d1e37609b372b96e832728e60dd5a0d75e943837311a" => :mountain_lion
  end

  depends_on "qt5"
  depends_on :java => :optional

  def install
    args = []
    args << "CONFIG+=qbs_enable_java" if build.with? "java"
    system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/", *args
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
