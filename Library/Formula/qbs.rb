require "formula"

class Qbs < Formula
  homepage "https://wiki.qt.io/Qt_Build_Suite"
  url "http://download.qt-project.org/official_releases/qbs/1.4.0/qbs-1.4.0.src.tar.gz"
  sha1 "4c70247155281b9536a6fab6672cd5f53610cfa1"

  bottle do
    sha256 "404755918b51067502789cc25e106b08f30d0e7c01b6b34099453ca54dc60f2f" => :yosemite
    sha256 "388a1436352700ce1dd1a58fe719b947958b2004bba8bc2b05c95d5f3a10a6a5" => :mavericks
    sha256 "67912c684898180768a415fcee0d576af669898ee676ed5048730e9526427674" => :mountain_lion
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
