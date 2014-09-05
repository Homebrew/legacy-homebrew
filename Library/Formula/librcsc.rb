require "formula"

class Librcsc < Formula
  homepage "http://sourceforge.jp/projects/rctools/"
  url "http://dl.sourceforge.jp/rctools/51941/librcsc-4.1.0.tar.gz"
  sha1 "2eaadd13fea559062053c571afe14b169f901136"

  bottle do
    cellar :any
    sha1 "65592801ed8334be4f419609f226526cb1acb358" => :mavericks
    sha1 "4c503946d3ad488fe9858a49826b51e63e1171fe" => :mountain_lion
    sha1 "d8aabc6ddddc9dd799f3341ecf6c5bf97aebc77f" => :lion
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrcsc_rcg"
    system "./test"
  end
end
