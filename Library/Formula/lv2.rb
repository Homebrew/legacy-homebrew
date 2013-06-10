require 'formula'

class Lv2 < Formula
  homepage 'http://lv2plug.in'
  url 'http://lv2plug.in/spec/lv2-1.4.0.tar.bz2'
  sha1 'df78eb0983981a510806b6765d7ad72c0204be18'

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2"
    system "./waf", "build"
    system "./waf", "install"
  end
end
