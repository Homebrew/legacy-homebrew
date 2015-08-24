class Qbs < Formula
  desc "Qt Build Suite"
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "https://download.qt.io/official_releases/qbs/1.4.2/qbs-src-1.4.2.tar.gz"
  sha256 "b9d36118c3ae0f7d4df6bf7239a0a0163c0340b701d00191fa5f832cef341ce5"

  bottle do
    sha256 "1a97288225e37a20e8686e5fa2cbbfed4f812becd03f1eb39e5ca9e9364273a3" => :yosemite
    sha256 "d1af3eccc7ed1ad98dee8eeb54739334648b68138784f7f672214037be9b9cea" => :mavericks
    sha256 "d05570afa0827c1adbf3d1e37609b372b96e832728e60dd5a0d75e943837311a" => :mountain_lion
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
