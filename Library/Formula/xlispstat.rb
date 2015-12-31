class Xlispstat < Formula
  desc "Statistical data science environment based on Lisp"
  homepage "http://homepage.stat.uiowa.edu/~luke/xls/xlsinfo/"
  url "http://homepage.cs.uiowa.edu/~luke/xls/xlispstat/current/xlispstat-3-52-23.tar.gz"
  version "3-52-23"
  sha256 "9bf165eb3f92384373dab34f9a56ec8455ff9e2bf7dff6485e807767e6ce6cf4"
  depends_on :x11

  def install
     system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "unset MAKEFLAGS;make; make install" # MAKEFLAGS -j4 causes problems in bytecompiling lisp code
  end

  test do
    system "echo \"(median (iseq 1 100))\" | #{bin}/xlispstat"
  end
end
