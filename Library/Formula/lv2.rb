class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "http://lv2plug.in"
  url "http://lv2plug.in/spec/lv2-1.12.0.tar.bz2"
  sha256 "7a4a53138f10ed997174c8bc5a8573d5f5a5d8441aaac2de6cf2178ff90658e9"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8ad6c88d4ea316fc2e1e15504b3cc88e634e072508932e4278da6824471ac539" => :el_capitan
    sha256 "a4a75ab0aca13e96c7fe10568ddd905bd511909e3a1cb84d1f640cce6e90acc6" => :yosemite
    sha256 "ce29adad60e4b904f15e15cfde2cd07f5a2490e7053279a605db0b87a0e7bdd1" => :mavericks
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--no-plugins"
    system "./waf", "build"
    system "./waf", "install"
  end
end
