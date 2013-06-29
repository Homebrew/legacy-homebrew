require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://sourceforge.net/projects/glfw/files/glfw/2.7.9/glfw-2.7.9.zip'
  sha1 '9356f4e2f50466ec0fff81497ce560d6007474b9'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
