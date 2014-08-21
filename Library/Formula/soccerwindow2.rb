require "formula"

class Soccerwindow2 < Formula
  homepage "http://sourceforge.jp/projects/rctools/"
  url "http://dl.sourceforge.jp/rctools/51942/soccerwindow2-5.1.0.tar.gz"
  sha1 "366f80591d39aaca0717bc2fb8993e0b5eb50ef2"

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "boost"
  depends_on "librcsc"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/soccerwindow2 -v | grep 'soccerwindow2 Version #{version}'"
  end
end
