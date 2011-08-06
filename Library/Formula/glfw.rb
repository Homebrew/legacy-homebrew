require 'formula'

class Glfw < Formula
  url 'http://downloads.sourceforge.net/project/glfw/glfw/2.7.1/glfw-2.7.1.tar.bz2'
  homepage 'http://www.glfw.org/'
  md5 '1cf551916124fccfc303fa4e50080f91'

  def install
    ENV.prepend 'PREFIX', "#{prefix}"
    system "make cocoa-install"
  end
end
