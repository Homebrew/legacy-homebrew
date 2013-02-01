require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://downloads.sourceforge.net/project/glfw/glfw/2.7.7/glfw-2.7.7.tar.bz2'
  sha1 'fce3baff5ae8ca8583fe91e63a23c3aad593b016'

  def install
    system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
  end
end
