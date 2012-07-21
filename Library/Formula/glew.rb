require 'formula'

class Glew < Formula
  homepage 'http://glew.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/glew/glew/1.8.0/glew-1.8.0.tgz'
  sha1 '641c6bb3f924ec786e1e6cf2b1b230f594e0f0e4'

  def install
    system "make", "GLEW_DEST=#{prefix}", "all"
    system "make", "GLEW_DEST=#{prefix}", "install.all"
  end
end
