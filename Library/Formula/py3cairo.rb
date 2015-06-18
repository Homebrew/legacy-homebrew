class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "http://cairographics.org/pycairo/"
  url "http://cairographics.org/releases/pycairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/pycairo-1.10.0.tar.bz2"
  sha256 "9aa4078e7eb5be583aeabbe8d87172797717f95e8c4338f0d4a17b683a7253be"
  revision 1

  bottle do
    sha256 "9737019a42ef35ddc90e8cbc3b369138a91b090c602cb984f9cf71f425086b0e" => :yosemite
    sha256 "7285e60a9d1120df9e4f14d491993d3c1bc8229720fb970783c712021ada4412" => :mavericks
    sha256 "85d007ca2dcfdd916aa254b15672168b58e4f3fc3f012be8ff84aff8139e8926" => :mountain_lion
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
