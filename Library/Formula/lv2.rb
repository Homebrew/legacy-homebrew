class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "http://lv2plug.in"
  url "http://lv2plug.in/spec/lv2-1.12.0.tar.bz2"
  sha256 "7a4a53138f10ed997174c8bc5a8573d5f5a5d8441aaac2de6cf2178ff90658e9"

  bottle do
    cellar :any
    sha256 "e682bb3d9dea26c66b139f21ab9a64e8a7ffcf283dd70223fc7fb81bf7942d5b" => :yosemite
    sha256 "9dfb6260a6590324b504c649d1af839603414a6d76c390fc4a0b24671b0d45a2" => :mavericks
    sha256 "cc96aedd80560fd38ce73bf5aa4e925c4836b570da37e9556131113e1666da32" => :mountain_lion
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2", "--no-plugins"
    system "./waf", "build"
    system "./waf", "install"
  end
end
