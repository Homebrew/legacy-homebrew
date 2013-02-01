require 'formula'

class Lv2 < Formula
  homepage 'http://lv2plug.in'
  url 'http://lv2plug.in/spec/lv2-1.2.0.tar.bz2'
  sha1 '5affb79b357c8f8d7f77cceb7252392845d3e072'

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2"
    system "./waf", "build"
    system "./waf", "install"
  end
end
