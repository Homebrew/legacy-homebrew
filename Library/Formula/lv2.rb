require "formula"

class Lv2 < Formula
  homepage "http://lv2plug.in"
  url "http://lv2plug.in/spec/lv2-1.10.0.tar.bz2"
  sha1 "182f8358808719edfcad535ff9c53d3e1dbce3f4"

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2", "--no-plugins"
    system "./waf", "build"
    system "./waf", "install"
  end
end
