require 'formula'

class Py3cairo < Formula
  homepage 'http://cairographics.org/pycairo/'
  url 'http://cairographics.org/releases/pycairo-1.10.0.tar.bz2'
  sha1 'b4283aa1cc9aafd12fd72ad371303a486da1d014'

  depends_on 'pkg-config' => :build
  depends_on 'cairo'
  depends_on :x11
  depends_on :python3

  def install
    ENV['PYTHON'] = "python3"
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
