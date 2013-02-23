require 'formula'

class Glew < Formula
  homepage 'http://glew.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/glew/glew/1.9.0/glew-1.9.0.tgz'
  sha1 '9291f5c5afefd482c7f3e91ffb3cd4716c6c9ffe'

  def install
    system "make", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_DEST=#{prefix}", "install.all"
  end
end
