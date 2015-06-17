class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "http://cairographics.org/pycairo/"
  url "http://cairographics.org/releases/pycairo-1.10.0.tar.bz2"
  sha256 "9aa4078e7eb5be583aeabbe8d87172797717f95e8c4338f0d4a17b683a7253be"

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
