require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://sourceforge.net/projects/glfw/files/glfw/2.7.8/glfw-2.7.8.zip'
  sha1 'b4f51221ffed0a064bb413074544a530ae2751ec'

  def install
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
