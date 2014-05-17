require 'formula'

class Lv2 < Formula
  homepage 'http://lv2plug.in'
  url 'http://lv2plug.in/spec/lv2-1.8.0.tar.bz2'
  sha1 '2c2d0e5cb0586adb835b842194583bf4fb7f3d0f'

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2"
    system "./waf", "build"
    system "./waf", "install"
  end
end
