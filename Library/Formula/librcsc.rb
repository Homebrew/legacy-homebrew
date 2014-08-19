require "formula"

class Librcsc < Formula
  homepage "http://sourceforge.jp/projects/rctools/"
  url "http://dl.sourceforge.jp/rctools/51941/librcsc-4.1.0.tar.gz"
  sha1 "2eaadd13fea559062053c571afe14b169f901136"

  depends_on "boost"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/librcsc-config --version | grep '#{version}'"
  end
end
