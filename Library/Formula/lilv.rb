class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.22.0.tar.bz2"
  sha256 "cd279321223ef11ca01551767d3c16d68cb31f689e02320a0b2e37b4f7d17ab4"

  bottle do
    cellar :any
    revision 1
    sha256 "bdece8afbd612253dc269a2259d01ab99c27c6383c8244bc27e4da7e5a5ce2e4" => :el_capitan
    sha256 "d5310728dc038ea81fb298bdc740d11ecba02a917f1f54472459539cf8b2f54d" => :yosemite
    sha256 "0cc10d77bb89587c07f3f23ddbed630a861ecc73f1da8efa9b36958a04406964" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
