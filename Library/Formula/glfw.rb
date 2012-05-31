require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://downloads.sourceforge.net/project/glfw/glfw/2.7.5/glfw-2.7.5.tar.bz2'
  sha1 '5a2415436dbba4c2b1f5ee29bcfed449b4ec98a0'

  def install
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
