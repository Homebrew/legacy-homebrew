require 'formula'

class Lv2core < Formula
  url 'http://lv2plug.in/spec/lv2core-3.0.tar.bz2'
  homepage 'http://lv2plug.in'
  md5 '382f7d96ff0374c0c495336e1c8bb999'

  def install
    system "./waf configure --prefix=#{prefix} --lv2dir=#{share}/lv2"
    system "./waf build"
    system "./waf install"
  end
end
