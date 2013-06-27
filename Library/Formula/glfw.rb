require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://sourceforge.net/projects/glfw/files/glfw/2.7.8/glfw-2.7.8.zip'
  sha1 'b4f51221ffed0a064bb413074544a530ae2751ec'

  option :universal

  conflicts_with 'glfw3',
    :because => "glfw and glfw3 install the same library libglfw.dylib."

  def install
    ENV.universal_binary if build.universal?
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
