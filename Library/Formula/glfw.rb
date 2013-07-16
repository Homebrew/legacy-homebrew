require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'https://github.com/glfw/glfw/archive/3.0.1.tar.gz'
  sha1 '6bdad407a050b792c85ccf127a1a25ee576a6e43'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
