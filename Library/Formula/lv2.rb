require "formula"

class Lv2 < Formula
  homepage "http://lv2plug.in"
  url "http://lv2plug.in/spec/lv2-1.12.0.tar.bz2"
  sha1 "fc914f00d3230354145748a2a4e55df0a03bcbe2"

  bottle do
    cellar :any
    sha1 "df2e95bc5e66e21910b24296e7abf5bf38f521ed" => :yosemite
    sha1 "f61a2ea63098cbcebe6747bd855aa45c8c1cdbde" => :mavericks
    sha1 "e435c12326408f004e3bcda8506a1093b8bf8d09" => :mountain_lion
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2", "--no-plugins"
    system "./waf", "build"
    system "./waf", "install"
  end
end
