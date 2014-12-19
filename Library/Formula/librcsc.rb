require "formula"

class Librcsc < Formula
  homepage "http://sourceforge.jp/projects/rctools/"
  url "http://dl.sourceforge.jp/rctools/51941/librcsc-4.1.0.tar.gz"
  sha1 "2eaadd13fea559062053c571afe14b169f901136"

  bottle do
    cellar :any
    revision 1
    sha1 "7db2070cbe574575393712c697fc743a138129e7" => :yosemite
    sha1 "27075e4e199258cc61e287464d7bf255fc4702ac" => :mavericks
    sha1 "9607e6d54b8a36202294ed27a71b2142cee8ee95" => :mountain_lion
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
