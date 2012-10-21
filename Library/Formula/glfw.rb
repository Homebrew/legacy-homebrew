require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://downloads.sourceforge.net/project/glfw/glfw/2.7.6/glfw-2.7.6.tar.bz2'
  sha1 '1c278a6b9e3622eabc9b5b5e9eff3bc29437955d'

  def install
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
