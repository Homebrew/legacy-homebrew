require 'formula'

class Glew < Formula
  url 'http://downloads.sourceforge.net/project/glew/glew/1.6.0/glew-1.6.0.tgz'
  homepage 'http://glew.sourceforge.net/'
  md5 '7dfbb444b5a4e125bc5dba0aef403082'

  def install
    (lib+'pkgconfig').mkpath
    system "make", "GLEW_DEST=#{prefix}"
    system "make", "GLEW_DEST=#{prefix}", "install"
  end
end
