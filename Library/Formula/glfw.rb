require 'formula'

class Glfw <Formula
  url 'http://prdownloads.sourceforge.net/glfw/glfw-2.7.tar.bz2'
  homepage 'http://www.glfw.org/'
  md5 'cc024566d78279c6af728ba2812c9107'

  def install
    ENV.prepend 'PREFIX', "#{prefix}"
    system "make cocoa-install"
  end
end
