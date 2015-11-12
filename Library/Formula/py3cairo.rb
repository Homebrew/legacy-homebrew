class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "http://cairographics.org/pycairo/"
  url "http://cairographics.org/releases/pycairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/pycairo-1.10.0.tar.bz2"
  sha256 "9aa4078e7eb5be583aeabbe8d87172797717f95e8c4338f0d4a17b683a7253be"
  revision 2

  bottle do
    sha256 "4966f5d8a46791b1a407ed16295eb64b921e9885face7fbcb09cf2abfdf1cae5" => :el_capitan
    sha256 "57cb5e7d61589ab8761d54a1455e527227998f79251e60c279088ffc99d0ff1b" => :yosemite
    sha256 "e3dd34a3a8bb72d817fd1a146a7b929bb41894aa6f1776943d62e5ab8b683394" => :mavericks
    sha256 "d507a98dd41b604fd639f7e15c3e1d674fe83b52dec336189e71d3206c65ff3e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python3

  def install
    ENV["PYTHON"] = "python3"
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
