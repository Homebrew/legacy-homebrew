require 'formula'

class Glew < Formula
  homepage 'http://glew.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/glew/glew/1.8.0/glew-1.8.0.tgz'
  md5 '07c47ad0253e5d9c291448f1216c8732'

  def install
    system "make", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_DEST=#{prefix}", "install.all"
  end 
end

