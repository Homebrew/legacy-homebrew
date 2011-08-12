require 'formula'

class Glfw < Formula
  url 'http://downloads.sourceforge.net/project/glfw/glfw/2.7.2/glfw-2.7.2.tar.bz2'
  homepage 'http://www.glfw.org/'
  md5 'bb4f33b43e40f8cd3015a653dca02ed1'

  def install
    ENV.prepend 'PREFIX', "#{prefix}"
    system "make cocoa-install"
  end
end
