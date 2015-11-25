class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://osdn.jp/projects/rctools/"
  url "http://dl.osdn.jp/rctools/51941/librcsc-4.1.0.tar.gz"
  sha256 "1e8f66927b03fb921c5a2a8c763fb7297a4349c81d1411c450b180178b46f481"

  bottle do
    cellar :any
    revision 1
    sha256 "c339890cbed4a1ca1b0a14d4375ece92ccee44a1f29023e1f633e9a9e0d6b6d5" => :yosemite
    sha256 "db8f74fadedc34da92c2109c1bbb90971c494e104c6041f1c8429def7f14dbc9" => :mavericks
    sha256 "ac8ae186e76e68384bc66b331757f877c0b02c6472f88b1e846b3b1065dd6ffa" => :mountain_lion
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
