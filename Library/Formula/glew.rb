require 'formula'

class Glew < Formula
  homepage 'http://glew.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/glew/glew/1.7.0/glew-1.7.0.tgz'
  md5 'fb7a8bb79187ac98a90b57f0f27a3e84'

  def install
    system "make", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_DEST=#{prefix}", "install.all"
  end
end
