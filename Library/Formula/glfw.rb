require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'https://github.com/glfw/glfw/archive/3.0.1.tar.gz'
  sha1 'ad73150e884687b7b413ec3abf5b0cc2c5c0df51'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
