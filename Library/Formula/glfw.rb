require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://downloads.sourceforge.net/project/glfw/glfw/2.7.3/glfw-2.7.3.tar.bz2'
  md5 'f0e40049cc3ef30cb145047a7631ab3f'

  def install
    system "make", "PREFIX=#{prefix}", "cocoa-install"
  end
end
