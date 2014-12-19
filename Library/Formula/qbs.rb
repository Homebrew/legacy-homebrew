require "formula"

class Qbs < Formula
  homepage "http://qt-project.org/wiki/qbs"
  url "http://download.qt-project.org/official_releases/qbs/1.3.2/qbs-1.3.2.src.tar.gz"
  sha1 "ce2d807c145e239d39e360521d62486eb1e3d108"

  bottle do
    cellar :any
    sha1 "cc8d1816df4336ab9d8745e332efb3081ac8abf7" => :yosemite
    sha1 "f95dc259474a8006364b62f7fcbc943783a6ccd9" => :mavericks
    sha1 "bbdadfad3bc1d7a6024b42245999d460ad719515" => :mountain_lion
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

    system "#{bin}/qbs", "run", "-f", "test.qbp", "profile:clang"
  end
end
